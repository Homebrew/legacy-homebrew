require 'formula'

# resty is a bash wrapper around curl for testing HTTP/REST APIs.

class Resty <Formula
  head 'git://github.com/micha/resty.git'
  homepage 'http://github.com/micha/resty'

  def install
    system "mv README.markdown README"
    # Note: pp depends on perl JSON module, which we don't install for you.
    bin.install %w[pp resty]
  end
end
