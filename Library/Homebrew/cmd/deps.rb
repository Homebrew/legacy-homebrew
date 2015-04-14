require 'formula'
require 'ostruct'
require 'set'

module Homebrew
  def deps
    mode = OpenStruct.new(
      :installed?  => ARGV.include?('--installed'),
      :tree?       => ARGV.include?('--tree'),
      :all?        => ARGV.include?('--all'),
      :topo_order? => ARGV.include?('-n'),
      :union?      => ARGV.include?('--union'),
      :dot?        => ARGV.include?('--dot')
    )

    if mode.installed? && mode.tree?
      puts_deps_tree Formula.installed
    elsif mode.dot?
      if mode.installed?
        puts_deps_dot(Formula.installed)
      elsif mode.all?
        puts_deps_dot(Formula)
      else
        raise FormulaUnspecifiedError if ARGV.named.empty?
        puts_deps_dot(ARGV.formulae)
      end
    elsif mode.installed?
      puts_deps Formula.installed
    elsif mode.all?
      puts_deps Formula
    elsif mode.tree?
      raise FormulaUnspecifiedError if ARGV.named.empty?
      puts_deps_tree ARGV.formulae
    else
      raise FormulaUnspecifiedError if ARGV.named.empty?
      all_deps = deps_for_formulae(ARGV.formulae, !ARGV.one?, &(mode.union? ? :| : :&))
      all_deps = all_deps.sort_by(&:name) unless mode.topo_order?
      puts all_deps
    end
  end

  def deps_for_formula(f, recursive=false)
    ignores = []
    ignores << "build?" if ARGV.include? "--skip-build"
    ignores << "optional?" if ARGV.include? "--skip-optional"

    if recursive
      deps = f.recursive_dependencies.reject do |dep|
        ignores.any? { |ignore| dep.send(ignore) }
      end
      reqs = f.recursive_requirements.reject do |req|
        ignores.any? { |ignore| req.send(ignore) }
      end
    else
      deps = f.deps.reject do |dep|
        ignores.any? { |ignore| dep.send(ignore) }
      end
      reqs = f.requirements.reject do |req|
        ignores.any? { |ignore| req.send(ignore) }
      end
    end

    deps + reqs.select(&:default_formula?).map(&:to_dependency)
  end

  def deps_for_formulae(formulae, recursive=false, &block)
    formulae.map {|f| deps_for_formula(f, recursive) }.inject(&block)
  end

  def puts_deps(formulae)
    formulae.each { |f| puts "#{f.name}: #{deps_for_formula(f).sort_by(&:name) * " "}" }
  end

  def puts_deps_tree(formulae)
    formulae.each do |f|
      puts f.name
      recursive_deps_tree(f, 1)
      puts
    end
  end

  def recursive_deps_tree f, level
    f.requirements.select(&:default_formula?).each do |req|
      puts "|  "*(level-1) + "|- :#{req.to_dependency.name}"
    end
    f.deps.default.each do |dep|
      puts "|  "*(level-1) + "|- #{dep.name}"
      recursive_deps_tree(Formulary.factory(dep.name), level+1)
    end
  end

  # Public: Prints a Graphviz representatition of the given formulas dependecies
  #
  # formulae  - formulae to evaluate
  #
  # Examples
  #
  #   puts_deps_dot(Formula.Installed) #Assuming only libpng is installed
  #    # =>
  #    digraph brew{
  #      _xz [label="xz"];
  #      _libpng [label="libpng"];
  #      _libpng -> _xz;
  #    }
  # Returns nothing, prints graph to standard out
  def puts_deps_dot(formulae)
    nodes = Hash.new
    edges = Set.new
    formulae.each do |f|
      tnodes, tedges = build_dots_hash(f)
      nodes.merge!(tnodes)
      edges.merge(tedges)
    end
    puts "digraph brew{"
    nodes.each { |k, v| puts "#{k} [label=\"#{v}\"];" }
    edges.each { |k, v| puts "#{k} -> #{v};" }

    puts "}"
    puts
  end

  # Private: Cleans the given name to play nice with graphviz
  #
  # name  - name to be cleaned
  #
  # Returns cleaned name
  def clean_name(name)
    return name.tr('.', '_dot_').tr('-', '_dash_')
        .tr('+', '_plus_').tr('/', '_fslash_')
  end

  # Private: Recursively builds a hash and set containing dependency relations
  # between given formula and its dependecies
  #
  # formula - formula to evaluate
  #
  # Returns Hash containing mapping from graphviz safe name to original formula
  #   name, Set containing directed relationship between formula and
  #   its dependencies
  def build_dots_hash(formula)
    nodes = Hash.new
    edges = Set.new
    fname = "_" + clean_name(formula.name)
    nodes[fname] = formula.name

    formula.requirements.select(&:default_formula?).each do |req|
      name = req.to_dependency.name
      label = "_" + clean_name(name)
      nodes[label] = name
      edges.add([fname,label])
    end

    formula.deps.default.each do |dep|
      name = dep.name
      label = "_" + clean_name(name)
      nodes[label] = name
      edges.add([fname,label])
      tnodes, tedges = build_dots_hash Formulary.factory(name)
      nodes.merge!(tnodes)
      edges = edges.union(tedges)
    end
    return nodes, edges
  end

  private :clean_name, :build_dots_hash

end
