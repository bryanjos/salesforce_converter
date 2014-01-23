defmodule SalesforceConverter.ExtensionFinder do

	def getFileType(binary) do
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

	defp getOfficeExtension(subheader) do
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