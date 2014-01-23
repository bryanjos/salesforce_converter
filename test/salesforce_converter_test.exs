defmodule SalesforceConverterTest do
  use ExUnit.Case

  test "Determine pdf file" do
  	fileType = SalesforceConverter.ExtensionFinder.getFileType("%PDF-1.4")
  	assert(fileType == "pdf")
  end

  test "Determine pdf file via hex" do
  	fileType = SalesforceConverter.ExtensionFinder.getFileType(Hex.decode("25504446"))
  	assert(fileType == "pdf")
  end  

  test "Determine xml file" do
  	fileType = SalesforceConverter.ExtensionFinder.getFileType("<?xml version=\"1.0\"?><MsInfo><Metadata>")
  	assert(fileType == "xml")
  end

  test "Determine rtf file" do
  	fileType = SalesforceConverter.ExtensionFinder.getFileType("{\\rtf1\\ansi\\ansicpg1252\\uc1 \\deff0\\deflang1033\\deflangfe1033{\\fonttbl{\\f0\\froman\\fcharset0\\fprq2{\\*\\panose")
  	assert(fileType == "rtf")
  end

  test "Determine jpg file" do
  	fileType = SalesforceConverter.ExtensionFinder.getFileType(Hex.decode("ffd8ff"))
  	assert(fileType == "jpg")
  end 	
end
