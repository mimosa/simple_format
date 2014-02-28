simple_format
======

* Translate emoji name or unicode to HTML images.
* Auto Link url and email.
* Clean HTML elements and attributes.


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
string = "This is a <span src='error'>:ruby:</span> <script type='text/javascript'>alert('Formater');</script>.\n\n Test Auto Link www.ruby-china.com\n\nmail@domain.com\n\nTest Emoji tag <a href=':cat:'>🍀</a>:ruby-china:."
SimpleFormat.h(string) # Emoji, Auto Link, Sanitize.clean
```
* return

``` html
This is a <span src=\"error\">:ruby:</span> alert('Formater');.<br><br> Test Auto Link <a href=\"http://www.ruby-china.com\" target=\"_blank\">www.ruby-china.com</a><br><br><a href=\"mailto:mail@domain.com\">mail@domain.com</a><br><br>Test Emoji tag <a href=\"&lt;img%20class=%22emoji%22%20src=%22//l.ruby-china.org/assets/emojis/cat.png%22%20width=%2264%22%20height=%2264%22%20/&gt;\"><img class=\"emoji\" src=\"//l.ruby-china.org/assets/emojis/four_leaf_clover.png\" width=\"64\" height=\"64\"></a>:ruby-china:.
```

``` ruby
SimpleFormat.auto_link(string)
```
* return 

``` html
This is a <span src='error'>:ruby:</span> <script type='text/javascript'>alert('Formater');</script>.<br /><br /> Test Auto Link <a href='http://www.ruby-china.com' target='_blank'>www.ruby-china.com</a><br /><br /><a href='mailto:mail@domain.com'>mail@domain.com</a><br /><br />Test Emoji tag <a href=':cat:'>🍀</a>:ruby-china:.
```

``` ruby
SimpleFormat.replace_emoji_with_images(string, 24) # Default img size is 64
```
* return

``` html
This is a <span src='error'>:ruby:</span> <script type='text/javascript'>alert('Formater');</script>.\n\n Test Auto Link www.ruby-china.com\n\nmail@domain.com\n\nTest Emoji tag <a href='<img class=\"emoji\" src=\"//l.ruby-china.org/assets/emojis/cat.png\" width=\"24\" height=\"24\" />'><img class=\"emoji\" src=\"//l.ruby-china.org/assets/emojis/four_leaf_clover.png\" width=\"24\" height=\"24\" /></a>:ruby-china:.
```

``` ruby
SimpleFormat.clean(string, {elements: [], attributes: { all: [] }})
=> "This is a :ruby: alert('Formater');.\n\n Test Auto Link www.ruby-china.com\n\nmail@domain.com\n\nTest Emoji tag 🍀:ruby-china:."

```