# -*- encoding: utf-8 -*-
require 'simple_format/version'
require 'simple_format/emoji'
require 'simple_format/auto_link'
require 'sanitize' unless defined?(::Sanitize)

module SimpleFormat
  extend self

  def h(string, size=64)
    return string unless string
    string = emoji.replace_emoji_with_images(string, size)
    string = auto_link(string)
    string = clean(string)
  end

  def replace_emoji_with_images(string, size=64)
    emoji.replace_emoji_with_images(string, size)
  end

  def clean(html, options = {})
    options = { elements: sanitized_allowed_tags, attributes: { all: sanitized_allowed_attributes } } if options.empty?
    Sanitize.clean(html, options)
  end

  def emoji
    @emoji ||= Emoji.new
  end

  private

  def sanitized_allowed_tags
    ['a', 'p', 'br', 'img', 'abbr', 'mark', 'm', 'fieldset', 'legend', 'label', 'summary', 'details', 'address', 'map', 'area', 'td', 'tr', 'th', 'thead', 'tbody', 'tfoot', 'caption', 'table', 'h4', 'h5', 'h6', 'hr', 'span', 'em', 'dl', 'dt', 'dd', 'b', 'del', 'ins', 'small', 'pre', 'blockquote', 'strong', 'audio', 'video', 'source', 'ul', 'ol', 'li', 'i', 'embed', 'sub', 'sup']
  end

  def sanitized_allowed_attributes
    ['shape', 'coords', 'target', 'href', 'muted', 'volume', 'name', 'class', 'title', 'border', 'poster', 'loop', 'autoplay', 'allowfullscreen', 'fullscreen', 'align' , 'quality', 'allowscriptaccess', 'wmode', 'flashvars', 'webkit-playsinline', 'x-webkit-airplay', 'data-original', 'src', 'controls', 'preload', 'type', 'width', 'height', 'size', 'alt']
  end

end