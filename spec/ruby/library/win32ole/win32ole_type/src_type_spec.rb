require_relative "../../../spec_helper"
platform_is :windows do
  require 'win32ole'

  describe "WIN32OLE::Type#src_type for Shell Controls" do
    before :each do
      @ole_type = WIN32OLE::Type.new("Microsoft Shell Controls And Automation", "Shell")
    end

    after :each do
      @ole_type = nil
    end

    it "returns nil" do
      @ole_type.src_type.should be_nil
    end

  end
end
