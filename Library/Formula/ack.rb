require 'brewkit'

class Ack <ScriptFileFormula
  # NOTE you don't need to specify the version, usually it is determined
  # automatically by examination of the URL, however in this case our auto
  # determination magic is inadequete
  @version='1.90'
  @url="http://ack.googlecode.com/svn/tags/#{@version}/ack"
  @md5='d15d059166beff6103d2401aa2d783c7'
  @homepage='http://betterthangrep.com/'

  # because our url looks like a svn one Homebrew defaults to the svn strategy
  def download_strategy
    HttpDownloadStrategy
  end
end