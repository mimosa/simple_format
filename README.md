simple_format
======

* Translate emoji name or unicode to HTML images.
* Auto Link url and email.
* Clean HTML elements and attributes.

[![Gem Version](https://badge.fury.io/rb/simple_format.png)](http://badge.fury.io/rb/simple_format)  [![Dependency Status](https://gemnasium.com/mimosa/simple_format.png?travis)](https://gemnasium.com/mimosa/rails-cache_control) [![Code Climate](https://codeclimate.com/github/mimosa/simple_format.png)](https://codeclimate.com/github/mimosa/simple_format)


Installation
------------

Add `simple_format` to your Gemfile.

``` ruby
gem 'simple_format'
```

Usage
---------------

``` ruby
require 'simple_format'
c = SimpleFormat::Converter.new
string = "This is a <span src='error'>:ruby:</span> <script type='text/javascript'>alert('Formater');</script>.\n\n Test Auto Link www.ruby-china.com\n\nmail@domain.com\n\nTest Emoji tag <a href=':cat:'>🍀</a>:ruby-china:." # 测试文本
```
------
``` ruby
c.rich_with(string) # 富文本转换（Emoji, nl2br, Auto Link, Sanitize.clean）
```
``` html
=> "This is a <span src=\"error\">:ruby:</span> alert('Formater');.<br><br> Test Auto Link <a href=\"http://www.ruby-china.com\" target=\"_blank\">www.ruby-china.com</a><br><br><a href=\"mailto:mail@domain.com\">mail@domain.com</a><br><br>Test Emoji tag <a href=\"&lt;img%20class=%22emoji%22%20src=%22//l.ruby-china.org/assets/emojis/cat.png%22%20width=%2264%22%20height=%2264%22%20/&gt;\"><img class=\"emoji\" src=\"//l.ruby-china.org/assets/emojis/four_leaf_clover.png\"></a>:ruby-china:."
```
----

``` ruby
c.auto_link('www.ruby-china.org') # 自动链接
```
``` html
=> "<a href='//www.ruby-china.org' target='_blank'>www.ruby-china.org</a>"
```
----

``` ruby
c.emoji_with('🍀') # 表情符
```
``` html
=> "<img class=\"emoji\" src=\"//l.ruby-china.org/assets/emojis/four_leaf_clover.png\" />"
```
----

``` ruby
c.text_with(string) # 清除 HTML
=> "This is a :ruby: alert('Formater');.\n\n Test Auto Link www.ruby-china.com\n\nmail@domain.com\n\nTest Emoji tag 🍀:ruby-china:."

```