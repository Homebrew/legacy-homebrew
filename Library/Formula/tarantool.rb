class Tarantool < Formula
  desc "In-memory database and Lua application server."
  homepage "http://tarantool.org"
  url "https://github.com/tarantool/tarantool/releases/download/1.6.8.525/tarantool-1.6.8.525.tar.gz"
  version "1.6.8-525"
  sha256 "570c1ef7cabf86d30a98a3b8c5020a956cee0882738b223b2a385b02f9fda70f"
  head "https://github.com/tarantool/tarantool.git", :shallow => false

  bottle do
    sha256 "d8c4c3b797f8a0707a5b58502db4af8e0700e6f93d54fd8376c4e2ea487eddc2" => :el_capitan
    sha256 "abbb7d67c4218b90afb2a82079af0fd79b8d3dca58e4704cda14cd50d0cb38f5" => :yosemite
    sha256 "4603c2baced36f51c11570d5a6cdaab2255dfe30a44cd78c20a22dc1bb3cb94d" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "readline"

  def install
    args = std_cmake_args
    args << "-DCMAKE_INSTALL_MANDIR=#{doc}"
    args << "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}"
    args << "-DCMAKE_INSTALL_LOCALSTATEDIR=#{var}"
    args << "-DENABLE_DIST=ON"

    system "cmake", ".", *args
    system "make"
    system "make", "install"
  end

  def post_install
    local_user = ENV["USER"]
    inreplace etc/"default/tarantool", /(username\s*=).*/, "\\1 '#{local_user}'"

    (var/"lib/tarantool").mkpath
    (var/"log/tarantool").mkpath
    (var/"run/tarantool").mkpath
  end

  test do
    (testpath/"test.lua").write <<-EOS.undent
        box.cfg{}
        local s = box.schema.create_space("test")
        s:create_index("primary")
        local tup = {1, 2, 3, 4}
        s:insert(tup)
        local ret = s:get(tup[1])
        if (ret[3] ~= tup[3]) then
          os.exit(-1)
        end
        os.exit(0)
    EOS
    system bin/"tarantool", "#{testpath}/test.lua"
  end
end
