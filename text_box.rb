class TextBox
	attr_gtk
	attr_reader :tags

	def initialize(args)
		@args = args
		@line_length = 30
		@labels = []
		@text = []			#raw text
		@x = 0
		@y = 0
		@size = 5
		@spacing = 28
		@tags = []
	end

	def clear
		@text.clear
		@labels.clear
	end

	def set_position(x, y)
		@x = x
		@y = y

		format_labels
	end

	def set_text(t)
		@text.clear
		@labels.clear
		@text = t

		format_labels
	end

	def chop_line(l)
		parts = []
		current = ""
		tag = ""
		status = 0		# 0 = normal text, 1 = tag, 2 = link
		pos = 0

		while pos < l.length
			if status == 0
				if l[pos] == "["
					parts << {type: :text, text: current}
					current = ""
					status = 1
				else
					current += l[pos]
				end
			elsif status == 1
				if l[pos] == "]"
					tag = current
					current = ""
					status = 2
				else
					current += l[pos]
				end
			elsif status == 2
				if l[pos] == " "
					parts << {type: :link, text: current, tag: tag}
					current = " "
					tag = ""
					status = 0
				else
					current += l[pos]
				end
			end
			
			pos += 1
		end

		if status == 0
			parts << {type: :text, text: current}
		else
			parts << {type: :link, text: current, tag: tag}
		end

		return parts
	end

	def format_labels()
		@tags = []

		@text.each_with_index do |l, i|
			elements = chop_line(l)
			xoff = 0
			for l in elements do
				w, h = @args.gtk.calcstringbox(l.text, @size, "font.ttf")
				

				if l.type == :link
					@labels << {x: @x + xoff, y: @y - (i * @spacing), text: l.text, size_enum: @size, b: 200}
					@tags << {tag: l.tag, rect: {x: @x + xoff, y: @y - ((i+1) * @spacing), w: w, h: h}}
				else
					@labels << {x: @x + xoff, y: @y - (i * @spacing), text: l.text, size_enum: @size}
				end

				xoff += w
			end
		end
	end

	def add_line(l)
		#print("add_line")

		@text << l

		format_labels()
	end

	def word_length(w)
		if w[0] == "["
			length = 0
			pos = 0
			inside_tag = true

			while pos < w.length
				if !inside_tag
					length += 1
				end

				if w[pos] == "]"
					inside_tag = false
				end

				pos += 1
			end

			return length
		else
			return w.length
		end
	end

	# add text and auto-wrap
	def add_wrapped(s)
		lines = []
		words = []
		current = ""
		line = ""
		pos = 0
#		length = 0
		inside_tag = false

		while pos < s.length
			current += s[pos]

			if s[pos] == " "
				words << current
				current = ""
			end

			pos += 1
		end

		words << current

		line = ""
		for w in words do
			if (line.length + word_length(w)) > @line_length
				lines << line
				line = w
			else
				line << w
			end
		end

		lines << line

		for l in lines do
			add_line(l)
		end
	end

	def draw
		return @labels
	end
end