require_relative "../../../spec_helper"
platform_is :windows do
  require 'win32ole'

  describe "WIN32OLE_VARIABLE#ole_type_detail" do
    # not sure how WIN32OLE_VARIABLE objects are supposed to be generated
    # WIN32OLE_VARIABLE.new even seg faults in some cases
    before :each do
      ole_type = WIN32OLE::Type.new("Microsoft Shell Controls And Automation", "ShellSpecialFolderConstants")
      @var = ole_type.variables[0]
    end

    it "returns a nonempty Array" do
      @var.ole_type_detail.should be_kind_of Array
      @var.ole_type_detail.should_not be_empty
    end

  end

end
