defmodule SalesforceConverter.FileExporter do

	def main(argv) do
		if Enum.empty? argv do
			IO.puts "Usage: ./salesforce_converter <path_to_exported_files>"
		else
			processFiles(hd(argv))
		end
	end

	def processFiles(dir) do
		createExportFolders(dir)
		Enum.each(createDocumentsList(dir), &read(dir, &1))		
	end

	def createExportFolders(dir) do
		if File.exists? "#{dir}/Exported" do
			File.rm_rf "#{dir}/Exported"		
		end

		if File.exists? "#{dir}/Unknown" do
			File.rm_rf "#{dir}/Unknown"		
		end

		File.mkdir "#{dir}/Exported"
		File.mkdir "#{dir}/Unknown"
	end

	def createDocumentsList(dir) do
		{_, attachments} = File.ls("#{dir}/Attachments")
		{_, documents} = File.ls("#{dir}/Documents")

		attachments = Enum.map(attachments, fn(x) -> dir <> "/Attachments/" <> x end)
		documents = Enum.map(documents, fn(x) -> dir <> "/Documents/" <> x end)

		Enum.concat(attachments, documents)
	end

	def read(dir, path) do
		case File.read(path) do
			{:ok, binary} ->
				SalesforceConverter.ExtensionFinder.getFileType(binary) 
				|> copyToExported(dir, path)
			{:error, reason} ->
				IO.puts reason
		end
	end

	def copyToExported(ext, dir, path) do
		filename = List.last(String.split(path, "/"))
		new_path = dir <> "/Unknown/" <> filename

		if ext != nil do
			filename = filename <> "." <> ext
			new_path = dir <> "/Exported/" <> filename
		end

		File.cp(path, new_path, fn(_, result) -> IO.puts result end)
	end
end