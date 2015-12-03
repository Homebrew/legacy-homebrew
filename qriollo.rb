# coding: utf-8
class Qriollo < Formula
  desc "Un lenguaje funcional, impuro, estricto, rioplatense y en joda."
  homepage "https://qriollo.github.io"
  url "https://qriollo.github.io/Qriollo-0.91.tar.gz"
  sha256 "c8357af8254a082d8e4da1de1bbf13bee27cfde8adb31ea0a5a0966bfbb7b28d"
  head "https://github.com/qriollo/qriollo.git"

  depends_on "ghc"

  def install
    system "make"
    bin.install "qr"
    (lib/"chamuyo").install "Chamuyo.q"
  end

  def caveats
    "El módulo estándar \"Chamuyo.q\" esta en el directorio #{lib/"chamuyo"}"
  end

  test do
    test_file_path = testpath/"HolaMundo.q"
    test_file_path.write <<-EOS.undent
      enchufar Chamuyo
      el programa es
         escupir "Hola mundo\n"
    EOS
    system bin/"qr", "--ruta", lib/"chamuyo", test_file_path
  end
end
