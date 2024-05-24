require 'app/text_box.rb'

def new_game args
	print("new_game")
	args.state.start_new = true

	args.state.main_text ||= TextBox.new(args)
	args.state.main_text.set_position(100, 500)

	#new_text = ["Lorem [tag1]ipsum dolor sit amet,", "consectetur adipiscing elitteger dolor [tag2]velit,",
    #   	   "[tag3]ultricies vitae libero vel,", "aliquam [tag4]imperdiet enim."]
	#args.state.main_text.set_text(new_text)

	args.state.main_text.add_wrapped("Lorem [tag1]ipsum dolor sit amet, consectetur adipiscing elitteger dolor [tag2]velit, [tag3]ultricies vitae libero vel, aliquam [tag4]imperdiet enim.")
end

def tick args
 	if !args.state.start_new
       new_game(args)
    end

	args.outputs.labels << args.state.main_text.draw

	for b in args.state.main_text.tags do
		args.outputs.borders << b[:rect]
	end

	if args.inputs.mouse.click
		for t in args.state.main_text.tags do
			if args.inputs.mouse.inside_rect? t[:rect]
				args.gtk.notify! "Link with tag #{t[:tag]}"
			end
		end
	end
end
