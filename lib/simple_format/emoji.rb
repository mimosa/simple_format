# -*- encoding: utf-8 -*-
require 'multi_json' unless defined?(::MultiJson)

module SimpleFormat
  class Emoji
    def initialize(mapping=nil)
      mapping ||= begin
        emoji_json = File.read(File.absolute_path(File.dirname(__FILE__) + '/../../config/index.json'))
        MultiJson.load(emoji_json, symbolize_keys: true)
      end
      
      @emoji_by_name = {}
      @emoji_by_unicode = {}

      mapping.each do |emoji_hash|
        name = emoji_hash[:name]
        @emoji_by_name[name] = emoji_hash if name

        unicode = emoji_hash[:unicode]
        @emoji_by_unicode[unicode] = emoji_hash if unicode
      end

      @emoji_name_regex = /:([a-z0-9\+\-_]+):/
      @emoji_unicode_regex = /#{@emoji_by_unicode.keys.join('|')}/
    end
    # 主机地址
    def asset_host
      @asset_host || '//emoji.qiniudn.com'
    end
    # 设置主机地址
    def asset_host=(host)
      @asset_host = host
    end
    # 资源路径 
    def asset_path
      @asset_path || '/'
    end
    # 设置路径
    def asset_path=(path)
      @asset_path = path
    end
    # 通过（名称、字符）替换表情 
    def replace_emoji_with_images(string, size='64')
      return string unless string

      html ||= string.dup
      html = replace_name_with_images(html, size)
      html = replace_unicode_with_images(html.to_str, size)
      return html
    end
    # 通过（名称）替换表情 
    def replace_name_with_images(string, size='64')
      unless string && string.match(names_regex)
        return string
      end

      string.to_str.gsub(names_regex) do |match|
        if names.include?($1)
          %Q{<img class="emoji" src="#{ image_url_for_name($1) }" width="#{size}" height="#{size}" />}
        else
          match
        end
      end
    end
    # 通过（字符）替换表情 
    def replace_unicode_with_images(string, size='64')
      unless string && string.match(unicodes_regex)
        return string
      end

      html ||= string.dup
      html.gsub!(unicodes_regex) do |unicode|
        %Q{<img class="emoji" src="#{ image_url_for_unicode(unicode) }" width="#{size}" height="#{size}" />}
      end
    end
    # 通过（名称）合成图片地址
    def image_url_for_name(name)
      "#{asset_host}#{ File.join(asset_path, name) }.png"
    end
    # 通过（字符）合成图片地址
    def image_url_for_unicode(unicode)
      emoji = find_by_unicode(unicode)
      image_url_for_name(emoji[:name]) unless emoji.nil?
    end
    # 通过（字符）找表情 
    def find_by_unicode(moji)
      @emoji_by_unicode[moji]
    end
    # 通过（名称）表情 
    def find_by_name(name)
      @emoji_by_name[name]
    end
    # 名称列表
    def names
      @emoji_by_name.keys
    end
    # 字符列表
    def unicodes
      @emoji_by_unicode.keys
    end
    # 名称匹配表达式
    def names_regex
      @emoji_name_regex
    end
    # 字符匹配表达式
    def unicodes_regex
      @emoji_unicode_regex
    end
  end
end