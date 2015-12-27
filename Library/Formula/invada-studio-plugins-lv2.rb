class InvadaStudioPluginsLv2 < Formula
  desc "LV2 audio plugins suite"
  homepage "https://launchpad.net/invada-studio/"
  url "https://launchpad.net/invada-studio/lv2/1.2/+download/invada-studio-plugins-lv2_1.2.0-nopkg.tgz"
  version "1.2.0"
  sha256 "c6cac7c32effc6b3052e3b017133244f385ef8e053147859d88eae6facaf7d12"
  head "lp:invada-studio/lv2", :using=>:bzr

  depends_on "lv2"
  depends_on "gtk+"

  def install
    system "make"
    system "make", "INSTALL_USER_PLUGINS_DIR=#{lib}/lv2", "install-user"
  end

  test do
    assert_match /_lv2_descriptor/, shell_output("nm  #{lib}/lv2/invada.lv2/inv_testtone.so")
  end
end
