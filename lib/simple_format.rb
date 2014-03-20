# -*- encoding: utf-8 -*-
require 'simple_format/version'
require 'simple_format/emoji'
require 'simple_format/auto_link'
require 'sanitize' unless defined?(::Sanitize)

module SimpleFormat
  class Converter
    def initialize(emoji=nil)
      @emoji = emoji if emoji.is_a?(SimpleFormat::Emoji)
    end

    def rich_with(string) # 转 富文本
      return string unless string
      string = emoji_with(string)
      string = nl2br(string).to_str
      string = auto_link(string)
      string = html_with(string)
      return string
    end

    def emoji_with(string) # 表情符 转 <img>
      emoji.replace_emoji_with_images(string)
    end

    def html_with(html, options = {})
      options = { elements: sanitized_allowed_tags, attributes: { all: sanitized_allowed_attributes } } if options.empty?
      Sanitize.clean(html, options)
    end

    def text_with(string) # 清除 html
      Sanitize.clean(string, {elements: [], attributes: { all: [] }})
    end

    def nl2br(string) # 回车 转 <br />
      if string
        string.gsub("\n\r","<br />").gsub("\r", "").gsub("\n", "<br />")
      end
    end

    def auto_link(string) # 链接转换
      @auto_link ||= AutoLink.new
      @auto_link.all(string) 
    end

    private

    def emoji
      @emoji || Emoji.new
    end

    def sanitized_allowed_tags
      ['a', 'p', 'br', 'img', 'abbr', 'mark', 'm', 'fieldset', 'legend', 'label', 'summary', 'details', 'address', 'map', 'area', 'td', 'tr', 'th', 'thead', 'tbody', 'tfoot', 'caption', 'table', 'h4', 'h5', 'h6', 'hr', 'span', 'em', 'dl', 'dt', 'dd', 'b', 'del', 'ins', 'small', 'pre', 'blockquote', 'strong', 'audio', 'video', 'source', 'ul', 'ol', 'li', 'i', 'embed', 'sub', 'sup']
    end

    def sanitized_allowed_attributes
      ['shape', 'coords', 'target', 'href', 'muted', 'volume', 'name', 'class', 'title', 'border', 'poster', 'loop', 'autoplay', 'allowfullscreen', 'fullscreen', 'align' , 'quality', 'allowscriptaccess', 'wmode', 'flashvars', 'webkit-playsinline', 'x-webkit-airplay', 'data-original', 'src', 'controls', 'preload', 'type', 'width', 'height', 'size', 'alt']
    end

  end
end