class Relx < Formula
  desc "Sane, simple release creation for Erlang"
  homepage "https://github.com/erlware/relx"
  url "https://github.com/erlware/relx.git", :tag => "v3.5.0",
                                             :revision => "2c8e17e366a548d54f319e8a62d6543d13c64d07"

  sha256 "107115778d98a07fe6e09b39ab8dbbf921af7cfb44ee143ed31e944fa5a3f865"

  head "https://github.com/erlware/relx.git"

  depends_on "erlang"

  def install
    system "./rebar3", "escriptize"
    bin.install "./_build/default/bin/relx"
  end

  test do
    system "#{bin}/relx", "--version"
    (testpath/"rebar.config").write <<-EOS.undent
      {sub_dirs, ["apps/test"]}.
    EOS
    (testpath/"relx.config").write <<-EOS.undent
      {release, {test, "0.0.1"}, [test]}.
    EOS
    mkdir_p "apps/test/src"
    (testpath/"apps/test/src/test.erl").write <<-EOS.undent
      -module(test).
      -export([test/0]).

      test() -> ok.
    EOS
    (testpath/"apps/test/src/test.app.src").write <<-EOS.undent
      {application,test,
               [{description,[]},
                {vsn,"1"},
                {registered,[]},
                {applications,[kernel,stdlib]},
                {mod,{test,[]}},
                {env,[]},
                {modules,[]}]}.
    EOS

    system "rebar", "compile"
    system "#{bin}/relx"
    assert File.exist? testpath/"_rel/test/bin/test"
  end
end
