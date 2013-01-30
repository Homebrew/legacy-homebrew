require 'testing_env'
require 'requirements'

class X11DependencyTests < Test::Unit::TestCase
  def test_eql_instances_are_eql
    x = X11Dependency.new
    y = X11Dependency.new
    assert x.eql?(y)
    assert y.eql?(x)
    assert x.hash == y.hash
  end

  def test_not_eql_when_hashes_differ
    x = X11Dependency.new("foo")
    y = X11Dependency.new
    assert x.hash != y.hash
    assert !x.eql?(y)
    assert !y.eql?(x)
  end

  def test_proxy_for
    x = X11Dependency::Proxy.for("libpng")
    assert_instance_of X11Dependency::Proxy::Libpng, x
    assert_kind_of X11Dependency, x
  end

  def test_proxy_eql_instances_are_eql
    x = X11Dependency::Proxy.for("libpng")
    y = X11Dependency::Proxy.for("libpng")
    assert x.eql?(y)
    assert y.eql?(x)
    assert x.hash == y.hash
  end

  def test_proxy_not_eql_when_hashes_differ
    x = X11Dependency::Proxy.for("libpng")
    y = X11Dependency::Proxy.for("fontconfig")
    assert x.hash != y.hash
    assert !x.eql?(y)
    assert !y.eql?(x)
  end

  def test_x_never_eql_to_proxy_x11_dep
    x = X11Dependency.new("libpng")
    p = X11Dependency::Proxy.for("libpng")
    assert !x.eql?(p)
    assert !p.eql?(x)
  end
end

class X11DepCollectionTests < Test::Unit::TestCase
  def setup
    @set = ComparableSet.new
  end

  def test_x_can_coxist_with_proxy
    @set << X11Dependency.new << X11Dependency::Proxy.for("libpng")
    assert_equal 2, @set.count
  end

  def test_multiple_proxies_can_coexist
    @set << X11Dependency::Proxy.for("libpng")
    @set << X11Dependency::Proxy.for("fontconfig")
    assert_equal 2, @set.count
  end
end
