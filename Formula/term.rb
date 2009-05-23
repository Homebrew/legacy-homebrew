$:.unshift "#{File.dirname __FILE__}/../Cellar/homebrew" #rubysucks
require 'brewkit'
require 'fileutils'

homepage='http://gist.github.com/116587'
url='http://gist.github.com/raw/116587/f253c26290fc0b79cd4ce5584b03585b311c28d8/term'

GithubGistFormula.new(url, '184301c748e1df92f07dee7879f17a08')