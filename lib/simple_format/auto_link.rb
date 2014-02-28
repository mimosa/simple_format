# -*- encoding: utf-8 -*-

module SimpleFormat
  extend self

  def auto_link(text, *args, &block) #link = :all, html = {}, &block)
    return text unless text

    options = {}
    unless args.empty?
      options[:link] = args[0] || :all
    end
    options.merge!(:link => :all)
    # 转换回行
    text = nl2br(text).to_str
    # 根据类型生成链接
    case options[:link].to_sym
      when :all             then auto_link_email_addresses(auto_link_urls(text, &block), &block)
      when :email_addresses then auto_link_email_addresses(text, &block)
      when :urls            then auto_link_urls(text, &block)
    end
  end

  private
  
  def nl2br(string)
    if string
      string.gsub("\n\r","<br />").gsub("\r", "").gsub("\n", "<br />")
    end
  end

  AUTO_LINK_RE = %r{
    (?: ((?:ed2k|ftp|http|https|irc|mailto|news|gopher|nntp|telnet|webcal|xmpp|callto|feed|svn|urn|aim|rsync|tag|ssh|sftp|rtsp|afs|file):)// | www\. )
    [^\s<]+
  }x

  # regexps for determining context, used high-volume
  AUTO_LINK_CRE = [/<[^>]+$/, /^[^>]*>/, /<a\b.*?>/i, /<\/a>/i]

  AUTO_EMAIL_RE = /[\w.!#\$%+-]+@[\w-]+(?:\.[\w-]+)+/

  BRACKETS = { ']' => '[', ')' => '(', '}' => '{' }

  WORD_PATTERN = RUBY_VERSION < '1.9' ? '\w' : '\p{Word}'

  # Turns all urls into clickable links.  If a block is given, each url
  # is yielded and the result is used as the link text.
  def auto_link_urls(text)
    
    text.gsub(AUTO_LINK_RE) do
      scheme, href = $1, $&
      punctuation = []

      if auto_linked?($`, $')
        # do not change string; URL is already linked
        href
      else
        # don't include trailing punctuation character as part of the URL
        while href.sub!(/[^#{WORD_PATTERN}\/-]$/, '')
          punctuation.push $&
          if opening = BRACKETS[punctuation.last] and href.scan(opening).size > href.scan(punctuation.last).size
            href << punctuation.pop
            break
          end
        end

        link_text = block_given?? yield(href) : href
        href = 'http://' + href unless scheme

        "<a href='#{href}' target='_blank'>#{link_text}</a>" + punctuation.reverse.join('')
      end
    end
  end

  # Turns all email addresses into clickable links.  If a block is given,
  # each email is yielded and the result is used as the link text.
  def auto_link_email_addresses(text)
    text.gsub(AUTO_EMAIL_RE) do
      text = $&
      if auto_linked?($`, $')
        text
      else
        display_text = (block_given?) ? yield(text) : text
        # mail_to text, display_text
        "<a href='mailto:#{text}'>#{display_text}</a>"
      end
    end
  end

  # Detects already linked context or position in the middle of a tag
  def auto_linked?(left, right)
    (left =~ AUTO_LINK_CRE[0] and right =~ AUTO_LINK_CRE[1]) or (left.rindex(AUTO_LINK_CRE[2]) and $' !~ AUTO_LINK_CRE[3])
  end
end