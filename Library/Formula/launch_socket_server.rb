class LaunchSocketServer < Formula
  desc "Bind to privileged ports without running a server as root"
  homepage "https://github.com/sstephenson/launch_socket_server"
  url "https://github.com/sstephenson/launch_socket_server/archive/v1.0.0.tar.gz"
  sha256 "77b7eebf54a1f0e0ce250b3cf3fa19eb6bee6cb6d70989a9b6cd5b6a95695608"

  head "https://github.com/sstephenson/launch_socket_server.git"

  depends_on "go" => :build

  def install
    system "make"

    sbin.install "sbin/launch_socket_server"
    (libexec/"launch_socket_server").install "libexec/launch_socket_server/login_wrapper"
  end

  test do
    assert_match /usage/, shell_output("#{sbin}/launch_socket_server")
  end
end
