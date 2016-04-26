class Xsd < Formula
  desc "XML Data Binding for C++"
  homepage "http://www.codesynthesis.com/products/xsd/"
  url "http://www.codesynthesis.com/download/xsd/4.0/xsd-4.0.0+dep.tar.bz2"
  version "4.0.0"
  sha256 "eca52a9c8f52cdbe2ae4e364e4a909503493a0d51ea388fc6c9734565a859817"

  bottle do
    cellar :any
    sha256 "8824a33e46d207c685620f71906d37d36a0a63953df81939ac36919d075729a4" => :el_capitan
    sha256 "1224c29a5fb429c32bf9e0267320492a85c7b3fac8d58d07d0c2b247f3af1362" => :yosemite
    sha256 "74014971be66fd561b27b6f92687115a8cf7bea04596ca8155e9e6ebb3715519" => :mavericks
    sha256 "de8d94a5cc933a23507b0c677f4756a400c2cc5e16c6dabdd5363fa61737b0f9" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "xerces-c"

  # Patches:
  # 1. As of version 4.0.0, Clang fails to compile if the <iostream> header is
  #    not explicitly included. The developers are aware of this problem, see:
  #    http://www.codesynthesis.com/pipermail/xsd-users/2015-February/004522.html
  # 2. As of version 4.0.0, building fails because this makefile invokes find
  #    with action -printf, which GNU find supports but BSD find does not. There
  #    is no place to file a bug report upstream other than the xsd-users mailing
  #    list (xsd-users@codesynthesis.com). I have sent this patch there but have
  #    received no response (yet).
  patch :DATA

  conflicts_with "mono", :because => "both install `xsd` binaries"

  def install
    ENV.append "LDFLAGS", `pkg-config --libs --static xerces-c`.chomp
    system "make", "install", "install_prefix=#{prefix}"
  end

  test do
    schema = testpath/"meaningoflife.xsd"
    schema.write <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" elementFormDefault="qualified"
               targetNamespace="http://brew.sh/XSDTest" xmlns="http://brew.sh/XSDTest">
        <xs:element name="MeaningOfLife" type="xs:positiveInteger"/>
    </xs:schema>
    EOS
    instance = testpath/"meaningoflife.xml"
    instance.write <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <MeaningOfLife xmlns="http://brew.sh/XSDTest" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://brew.sh/XSDTest meaningoflife.xsd">
        42
    </MeaningOfLife>
    EOS
    xsdtest = testpath/"xsdtest.cxx"
    xsdtest.write <<-EOS.undent
    #include <cassert>
    #include "meaningoflife.hxx"
    int main (int argc, char *argv[]) {
        assert(2==argc);
        std::auto_ptr< ::xml_schema::positive_integer> x = XSDTest::MeaningOfLife(argv[1]);
        assert(42==*x);
        return 0;
    }
    EOS
    system "#{bin}/xsd", "cxx-tree", schema
    assert File.exist? testpath/"meaningoflife.hxx"
    assert File.exist? testpath/"meaningoflife.cxx"
    system "c++", "-o", "xsdtest", "xsdtest.cxx", "meaningoflife.cxx", "-lxerces-c"
    assert File.exist? testpath/"xsdtest"
    system testpath/"xsdtest", instance
  end
end

__END__
diff --git a/libxsd-frontend/xsd-frontend/semantic-graph/elements.cxx b/libxsd-frontend/xsd-frontend/semantic-graph/elements.cxx
index fa48a9a..59994ae 100644
--- a/libxsd-frontend/xsd-frontend/semantic-graph/elements.cxx
+++ b/libxsd-frontend/xsd-frontend/semantic-graph/elements.cxx
@@ -2,6 +2,7 @@
 // copyright : Copyright (c) 2005-2014 Code Synthesis Tools CC
 // license   : GNU GPL v2 + exceptions; see accompanying LICENSE file

+#include <iostream>
 #include <algorithm>

 #include <cutl/compiler/type-info.hxx>
diff --git a/xsd/examples/cxx/tree/makefile b/xsd/examples/cxx/tree/makefile
index 172195a..d8c8198 100644
--- a/xsd/examples/cxx/tree/makefile
+++ b/xsd/examples/cxx/tree/makefile
@@ -39,7 +39,7 @@ $(install): $(addprefix $(out_base)/,$(addsuffix /.install,$(all_examples)))
 $(dist): $(addprefix $(out_base)/,$(addsuffix /.dist,$(all_examples)))
        $(call install-data,$(src_base)/README,$(dist_prefix)/$(path)/README)

-$(dist-win): export dirs := $(shell find $(src_base) -type d -exec test -f {}/driver.cxx ';' -printf '%P ')
+$(dist-win): export dirs := $(shell find "$(src_base)" -type d -exec test -f {}/driver.cxx ';' -exec bash -c 'd="{}"; printf "%s " "${d#'"$(src_base)"'/}"' ";")
 $(dist-win): |$(out_root)/.dist-pre
 $(dist-win): $(addprefix $(out_base)/,$(addsuffix /.dist-win,$(all_examples)))
        $(call install-data,$(src_base)/README,$(dist_prefix)/$(path)/README.txt)
