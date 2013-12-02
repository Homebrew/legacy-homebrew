require 'formula'

class IncludeWhatYouUse < Formula
  homepage 'https://code.google.com/p/include-what-you-use/'
  url 'https://doc-00-9o-docs.googleusercontent.com/docs/securesc/ha0ro937gcuc7l7deffksulhg5h7mbp1/63i6dla0uj8qk3q6nbbd9m5b1rjkkrmk/1385755200000/18138411108955853598/*/0ByBfuBCQcURXQktsT3ZjVmZtWkU?h=16653014193614665626&e=download'
  version '3.3'
  sha1 'f49dd094300b648543e3510ebd8101dbab23056f'

  depends_on 'llvm' => [:build, "with-clang"]
  depends_on 'cmake'

  def install
    mkdir '../build-iwyu' do
       system "cmake -DLLVM_PATH=/usr/local/Cellar/llvm/3.3/ ../include-what-you-use -DCMAKE_INSTALL_PREFIX=#{prefix}/"
       system "make install"
    end
    system "cp ../include-what-you-use/fix_includes.py #{prefix}/"
  end
end
