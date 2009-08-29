require 'brewkit'

class Ack <ScriptFileFormula
  @version='1.88'
  @url="http://ack.googlecode.com/svn/tags/#{@version}/ack"
  @md5='8009a13ab0fc66047bea0ea2ad89419c'
  @homepage='http://betterthangrep.com/'
  
  # because our url looks like a svn one Homebrew defaults to the svn strategy
  def download_strategy
    HttpDownloadStrategy
  end
end