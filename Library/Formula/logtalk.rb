require "formula"

class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "http://logtalk.org"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3004stable.tar.gz"
  sha256 "2f1275d43ec5c4c65161b4673ed214311272a8af131a748c37e2ffec33532dfc"
  version "3.00.4"

  option "swi-prolog", "Build using SWI Prolog as backend"
  option "gnu-prolog", "Build using GNU Prolog as backend (Default)"

  if build.include?("swi-prolog")
    depends_on "swi-prolog"
  else
    depends_on "gnu-prolog"
  end

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
