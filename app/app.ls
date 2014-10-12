$pull = $ \#pull
$menu = $ '#header ul'
$pull.click !->
  it.prevent-default!
  $menu.slide-toggle!
$ window .resize !->
  $menu.remove-attr \style if $ @ .width! > 320 && $menu.is \:hidden

$.scroll-it!
document.scroll-reveal = new scroll-reveal {+reset}

# vi:et:nowrap:sw=2:ts=2
