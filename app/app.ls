$pull = $ \#pull
$menu = $ '#header ul'
$pull.click !->
  it.prevent-default!
  $menu.slide-toggle!
$ window .resize !->
  $menu.remove-attr \style if $ @ .width! > 320 && $menu.is \:hidden

#is-local = false
n-wish = 0
#$.get \do?hp.html + (if is-local then \.local else ''), (data, textStatus, jqXHR) !->
#  data -= /[\s\S]*<body>|<(?:h1|p)>.*?<\/(?:h1|p)>|\n|<\/body>[\s\S]*/g
#  for v in (data - /^<h2>/) / \<h2> then wish v

#$.scroll-it!
#document.scroll-reveal = new scroll-reveal viewport-factor: 0

#$ \#wishes .on \click '.wish .response' -> show-panel \hackpad it
#$ \#disqus-trigger .click !-> show-panel \disqus it
#$ \#hackpad-trigger .click !-> show-panel \hackpad it

#wish-style = $.stylesheet '#wishes .wish'
#wish-width = parseInt wish-style.css \width
#wish-margin-left = parseInt wish-style.css \margin-left
#wish-margin-right = parseInt wish-style.css \margin-right
#$ window .resize !->
#  wishes-width = $ \#wishes .width!
#  n-column = Math.round(wishes-width / (wish-width + wish-margin-left + wish-margin-right)) >? 1
#  w = wishes-width / n-column - wish-margin-left - wish-margin-right - 0.5
#  wish-style.css height: w * 9 / 16 + \px width: w + \px
#.resize!

!function hide-panel
  $ '#disqus,#hackpad' .removeClass \active
  $ \#wrap .removeClass \inactive .off \click

!function show-panel panel, ev
  ev.stop-propagation!
  ev.prevent-default!
  $ '#disqus,#hackpad' .removeClass \active
  $ "##panel" .addClass \active
  $ \#wrap .addClass \inactive .click hide-panel

function wish
  unless par = it.match /^(.*?)<\/h2>/ then return
  url = par.1
  comment = it - /^.*?<\/h2>/

  fn =
    dribbble: (id, filename, callback) !->
      $.jribbble.getShotById id, !-> callback it.image_url
    dribbble-local: (id, filename, callback) !-> callback "res/#filename.png"
  if par = url is /^https?:\/\/dribbble.com\/shots\/(\d{6,7})(.*)$/
    fn[\dribbble + if is-local then \Local else ''] par.1, par.1 + par.2, _wish
  else if url is /^https?:\/\/.*\.(gif|jpg|jpeg|png)$/i => _wish url

  !function _wish
    $ \#n-wish .text ++n-wish
    if par = comment is /^<ul class="comment"><li>((?:.|\n)*)<\/li><\/ul>$/
      if like = par.1.match /\+\d+/g
        n-like = like.length
      else n-like = 0
      n-comment = (par.1 / "</li>\n<li>").length
    else n-like = 0; n-comment = 0

    $ \#wishes .append do
      $ \<div/>,
        class: \wish
        css: background: "url(#it) center / cover no-repeat"
      .append $ "
        <div class='response' title='comment via hackpad'>
          <i class='thumbs up icon'></i>#n-like&nbsp;&nbsp;
          <i class='comment icon'></i>#n-comment
        </div>",
        class: \response

    $ window .resize!

# vi:et:nowrap:sw=2:ts=2
