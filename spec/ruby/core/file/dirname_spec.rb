require_relative '../../spec_helper'

describe "File.dirname" do
  it "returns all the components of filename except the last one" do
    File.dirname('/home/jason').should == '/home'
    File.dirname('/home/jason/poot.txt').should == '/home/jason'
    File.dirname('poot.txt').should == '.'
    File.dirname('/holy///schnikies//w00t.bin').should == '/holy///schnikies'
    File.dirname('').should == '.'
    File.dirname('/').should == '/'
    File.dirname('/foo/foo').should == '/foo'
  end

  context "when level is passed" do
    it "returns all the components of filename except the last parts by the level" do
      File.dirname('/home/jason', 2).should == '/'
      File.dirname('/home/jason/poot.txt', 2).should == '/home'
    end

    it "returns the same String if the level is 0" do
      File.dirname('poot.txt', 0).should == 'poot.txt'
      File.dirname('/', 0).should == '/'
    end

    it "raises ArgumentError if the level is negative" do
      -> {
        File.dirname('/home/jason', -1)
      }.should raise_error(ArgumentError, "negative level: -1")
    end

    it "returns '/' when level exceeds the number of segments in the path" do
      File.dirname("/home/jason", 100).should == '/'
    end

    it "calls #to_int if passed not numeric value" do
      object = Object.new
      def object.to_int; 2; end

      File.dirname("/a/b/c/d", object).should == '/a/b'
    end
  end

  it "returns a String" do
    File.dirname("foo").should be_kind_of(String)
  end

  it "does not modify its argument" do
    x = "/usr/bin"
    File.dirname(x)
    x.should == "/usr/bin"
  end

  it "ignores a trailing /" do
    File.dirname("/foo/bar/").should == "/foo"
  end

  it "returns the return all the components of filename except the last one (unix format)" do
    File.dirname("foo").should =="."
    File.dirname("/foo").should =="/"
    File.dirname("/foo/bar").should =="/foo"
    File.dirname("/foo/bar.txt").should =="/foo"
    File.dirname("/foo/bar/baz").should =="/foo/bar"
  end

  it "returns all the components of filename except the last one (edge cases on all platforms)" do
    File.dirname("").should == "."
    File.dirname(".").should == "."
    File.dirname("./").should == "."
    File.dirname("./b/./").should == "./b"
    File.dirname("..").should == "."
    File.dirname("../").should == "."
    File.dirname("/").should == "/"
    File.dirname("/.").should == "/"
    File.dirname("/foo/").should == "/"
    File.dirname("/foo/.").should == "/foo"
    File.dirname("/foo/./").should == "/foo"
    File.dirname("/foo/../.").should == "/foo/.."
    File.dirname("foo/../").should == "foo"
  end

  platform_is_not :windows do
    it "returns all the components of filename except the last one (edge cases on non-windows)" do
      File.dirname('/////').should == '/'
      File.dirname("//foo//").should == "/"
      File.dirname('foo\bar').should == '.'
      File.dirname('/foo\bar').should == '/'
      File.dirname('foo/bar\baz').should == 'foo'
    end
  end

  platform_is :windows do
    it "returns all the components of filename except the last one (edge cases on windows)" do
      File.dirname("//foo").should == "//foo"
      File.dirname("//foo//").should == "//foo"
      File.dirname('/////').should == '//'
    end
  end

  it "accepts an object that has a #to_path method" do
    File.dirname(mock_to_path("/")).should == "/"
  end

  it "raises a TypeError if not passed a String type" do
    -> { File.dirname(nil)   }.should raise_error(TypeError)
    -> { File.dirname(0)     }.should raise_error(TypeError)
    -> { File.dirname(true)  }.should raise_error(TypeError)
    -> { File.dirname(false) }.should raise_error(TypeError)
  end

  # Windows specific tests
  platform_is :windows do
    it "returns the return all the components of filename except the last one (Windows format)" do
      File.dirname("C:\\foo\\bar\\baz.txt").should =="C:\\foo\\bar"
      File.dirname("C:\\foo\\bar").should =="C:\\foo"
      File.dirname("C:\\foo\\bar\\").should == "C:\\foo"
      File.dirname("C:\\foo").should == "C:\\"
      File.dirname("C:\\").should =="C:\\"
    end

    it "returns the return all the components of filename except the last one (windows unc)" do
      File.dirname("\\\\foo\\bar\\baz.txt").should == "\\\\foo\\bar"
      File.dirname("\\\\foo\\bar\\baz").should == "\\\\foo\\bar"
      File.dirname("\\\\foo").should =="\\\\foo"
      File.dirname("\\\\foo\\bar").should =="\\\\foo\\bar"
      File.dirname("\\\\\\foo\\bar").should =="\\\\foo\\bar"
      File.dirname("\\\\\\foo").should =="\\\\foo"
    end

    it "returns the return all the components of filename except the last one (forward_slash)" do
      File.dirname("C:/").should == "C:/"
      File.dirname("C:/foo").should == "C:/"
      File.dirname("C:/foo/bar").should == "C:/foo"
      File.dirname("C:/foo/bar/").should == "C:/foo"
      File.dirname("C:/foo/bar//").should == "C:/foo"
    end
  end
end
