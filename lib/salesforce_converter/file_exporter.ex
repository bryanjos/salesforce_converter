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
				determineFileType(binary) 
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

	def determineFileType(binary) do
		cond do
			String.starts_with? binary, "%PDF-" ->
				"pdf"
			String.starts_with? binary, "<?xml" ->
				"xml"
			String.starts_with? binary, "{\\rtf" ->
				"rtf"
			true ->
				hex = Hex.encode(binary)
				cond do
					String.starts_with? hex, "d0cf11e0" ->
						getOfficeExtension String.slice(hex, 1024, 16)
					String.starts_with? hex, "ffd8ff" ->
						"jpg"
					String.starts_with? hex, "25504446" ->
						"pdf"
					String.starts_with? hex, "504b0304" ->
						"zip"
					String.starts_with? hex, "4d5a9000" ->
						"exe"
					String.starts_with? hex, "89504e47" ->
						"png"
					String.starts_with? hex, "47494638" ->
						"gif"
					String.starts_with? hex, "424d" ->
						"bmp"
					true ->
						nil
				end
		end

	end

	def getOfficeExtension(subheader) do
		cond do
			String.starts_with? subheader, "fdffffff0e000000" ->
				"ppt"
			String.starts_with? subheader, "fdffffff1c000000" ->
				"ppt"
			String.starts_with? subheader, "fdffffff43000000" ->
				"ppt"
			String.starts_with? subheader, "fdffffff20000000" ->
				"xls"
			String.starts_with? subheader, "0908100000060500" ->
				"xls"
			String.starts_with? subheader, "fdffffff1000" ->
				"xls"
			String.starts_with? subheader, "fdffffff1002" ->
				"xls"
			String.starts_with? subheader, "fdffffff1f00" ->
				"xls"
			String.starts_with? subheader, "fdffffff1f02" ->
				"xls"
			String.starts_with? subheader, "fdffffff2200" ->
				"xls"
			String.starts_with? subheader, "fdffffff2202" ->
				"xls"
			String.starts_with? subheader, "fdffffff2300" ->
				"xls"
			String.starts_with? subheader, "fdffffff2302" ->
				"xls"
			String.starts_with? subheader, "fdffffff2800" ->
				"xls"
			String.starts_with? subheader, "fdffffff2802" ->
				"xls"
			String.starts_with? subheader, "fdffffff2900" ->
				"xls"
			String.starts_with? subheader, "fdffffff2902" ->
				"xls"
			String.starts_with? subheader, "006e1ef0" ->
				"ppt"
			String.starts_with? subheader, "eca5c100" ->
				"doc"
			String.starts_with? subheader, "0f00e803" ->
				"ppt"
			String.starts_with? subheader, "a0461df0" ->
				"ppt"
			String.starts_with? subheader, "fdffffff02" ->
				"pub"
			String.starts_with? subheader, "fdffffff04" ->
				"suo"
			true ->
				nil
		end		
	end
end