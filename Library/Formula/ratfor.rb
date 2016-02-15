class Ratfor < Formula
  desc "Rational Fortran"
  homepage "http://www.dgate.org/ratfor/"
  url "http://www.dgate.org/ratfor/tars/ratfor-1.02.tar.gz"
  sha256 "daf2971df48c3b3908c6788c4c6b3cdfb4eaad21ec819eee70a060956736ea1c"

  bottle do
    cellar :any_skip_relocation
    sha256 "6998ed33f7547a097ced8ce5407756c50145d21ece1c8cd3474e6c9eeefd89c7" => :el_capitan
    sha256 "2d368db5719c280340140998d525279a5f5178c0acccdecc7281f38f3d07c563" => :yosemite
    sha256 "0544b9e974932e28f090aad1c54dd0c6708ebf1d7a0d3657a150cdb4fdb0cf36" => :mavericks
  end

  depends_on :fortran

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.r").write <<-EOS.undent
      integer x,y
      x=1; y=2
      if(x == y)
              write(6,600)
      else if(x > y)
              write(6,601)
      else
              write(6,602)
      x=1
      while(x < 10){
        if(y != 2) break
        if(y != 2) next
        write(6,603)x
        x=x+1
        }
      repeat
        x=x-1
      until(x == 0)
      for(x=0; x < 10; x=x+1)
              write(6,604)x
      600 format('Wrong, x != y')
      601 format('Also wrong, x < y')
      602 format('Ok!')
      603 format('x = ',i2)
      604 format('x = ',i2)
      end
    EOS

    system "#{bin}/ratfor", "-o", "test.f", testpath/"test.r"
    ENV.fortran
    system ENV.fc, "test.f", "-o", "test"
    system "./test"
  end
end
