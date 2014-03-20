# -*- encoding: utf-8 -*-

module SimpleFormat
  class AutoLink

    def initialize()
      @regex = {
            protocol: %r{(?: ((?:ed2k|ftp|http|https|irc|mailto|news|gopher|nntp|telnet|webcal|xmpp|callto|feed|svn|urn|aim|rsync|tag|ssh|sftp|rtsp|afs|file):)// | www\. )[^\s<]+}x,
                href: [/<[^>]+$/, /^[^>]*>/, /<a\b.*?>/i, /<\/a>/i],
                mail: /[\w.!#\$%+-]+@[\w-]+(?:\.[\w-]+)+/,
            brackets: { ']' => '[', ')' => '(', '}' => '{' },
        word_pattern: RUBY_VERSION < '1.9' ? '\w' : '\p{Word}'
      }
    end

    def all(text)
      return text unless text
      email_addresses( urls(text) )
    end

    # Turns all urls into clickable links.  If a block is given, each url
    # is yielded and the result is used as the link text.
    def urls(text)
      
      text.gsub(@regex[:protocol]) do
        scheme, href = $1, $&
        punctuation = []

        if auto_linked?($`, $')
          # do not change string; URL is already linked
          href
        else
          # don't include trailing punctuation character as part of the URL
          while href.sub!(/[^#{@regex[:word_pattern]}\/-]$/, '')
            punctuation.push $&
            if opening = @regex[:brackets][punctuation.last] and href.scan(opening).size > href.scan(punctuation.last).size
              href << punctuation.pop
              break
            end
          end

          link_text = block_given?? yield(href) : href
          href = '//' + href unless scheme

          "<a href='#{href}' target='_blank'>#{link_text}</a>" + punctuation.reverse.join('')
        end
      end
    end

    # Turns all email addresses into clickable links.  If a block is given,
    # each email is yielded and the result is used as the link text.
    def email_addresses(text)
      text.gsub(@regex[:mail]) do
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

    private

    # Detects already linked context or position in the middle of a tag
    def auto_linked?(left, right)
      (left =~ @regex[:href][0] and right =~ @regex[:href][1]) or (left.rindex(@regex[:href][2]) and $' !~ @regex[:href][3])
    end
  end
end