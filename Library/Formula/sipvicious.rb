require 'formula'

class Sipvicious < Formula
  homepage 'http://code.google.com/p/sipvicious/'
  url 'http://sipvicious.googlecode.com/files/sipvicious-0.2.7.tar.gz'
  md5 'a30c9865d3eac5518d5fd9ced25424f1'
  
  def install
    prefix.install Dir['*']
    bin.install_symlink "#{prefix}/svcrack.py" => 'svcrack', 
                        "#{prefix}/svlearnfp.py" => 'svlearnfp',
                        "#{prefix}/svmap.py" => 'svmap',
                        "#{prefix}/svreport.py" => 'svreport',
                        "#{prefix}/svwar.py" => 'svwar'
  end  
end
