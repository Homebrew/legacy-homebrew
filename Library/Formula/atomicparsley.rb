require 'brewkit'

class Atomicparsley <Formula
  @url='http://downloads.sourceforge.net/project/atomicparsley/atomicparsley/AtomicParsley%20v0.9.0/AtomicParsley-source-0.9.0.zip'
  @homepage='http://atomicparsley.sourceforge.net/'
  @md5='681e6ecec2921c98e07a9262bdcd6cf2'

  def patches
    { :p0 => "http://pastie.org/609011.txt" }
  end

  def install
    Dir.chdir("AtomicParsley-source-0.9.0")
    system "g++ #{ENV['CXXFLAGS']} -o AtomicParsley -framework Cocoa -DDARWIN_PLATFORM *.mm *.cpp"
    bin.install "AtomicParsley"
  end
end
