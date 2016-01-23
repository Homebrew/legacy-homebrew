class Tarantool < Formula
  desc "In-memory database and Lua application server."
  homepage "http://tarantool.org"
  url "http://tarantool.org/dist/master/tarantool-1.6.7-593-gc17fa86-src.tar.gz"
  version "1.6.7-593"
  sha256 "21579278c732674149bfe55a4f408c47f44f7d2df6bfc71f3b12f004aa14bd1b"
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

    system "cmake", ".", *args
    system "make"
    system "make", "install"

    inreplace bin/"tarantoolctl", %r{\/usr\/local\/etc\/tarantool\/default\/tarantool}, "#{etc}/default/tarantool"
    inreplace etc/"default/tarantool" do |s|
      s.gsub!(/(pid_file\s*=).*/, "\\1 '#{var}/run/tarantool',")
      s.gsub!(/(wal_dir\s*=).*/, "\\1 '#{var}/lib/tarantool',")
      s.gsub!(/(snap_dir\s*=).*/, "\\1 '#{var}/lib/tarantool',")
      s.gsub!(/(sophia_dir\s*=).*/, "\\1 '#{var}/lib/tarantool',")
      s.gsub!(/(logger\s*=).*/, "\\1 '#{var}/log/tarantool',")
      s.gsub!(/(instance_dir\s*=).*/, "\\1 '#{etc}/tarantool/instances.enabled'")
    end

    (etc/"tarantool/instances.enabled").install_symlink "#{etc}/tarantool/instances.available/example.lua"
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
