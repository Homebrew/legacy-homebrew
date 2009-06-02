require 'brewkit'

class Ack <UncompressedScriptFormula
  def initialize
    @version='1.88'
    @url="http://ack.googlecode.com/svn/tags/#{@version}/ack"
    @md5='8009a13ab0fc66047bea0ea2ad89419c'
    @homepage='http://betterthangrep.com/'
  end
end