require 'app/text_box.rb'

def new_game args
	print("new_game")
	args.state.start_new = true

	args.state.main_text ||= TextBox.new(args)
	args.state.main_text.set_position(100, 300)

	#new_text = ["Lorem [tag1]ipsum dolor sit amet,", "consectetur adipiscing elitteger dolor [tag2]velit,",
    #   	   "[tag3]ultricies vitae libero vel,", "aliquam [tag4]imperdiet enim."]
	#args.state.main_text.set_text(new_text)

	args.state.main_text.add_wrapped("Lorem [tag1]ipsum dolor sit amet, consectetur adipiscing elitteger dolor [tag2]velit, [tag3]ultricies vitae libero vel, aliquam [tag4]imperdiet enim.")
	args.state.main_text.add_wrapped("quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.")
	args.state.main_text.add_wrapped("Duis aute irure dolor in reprehenderit in voluptate velit esse
										cillum dolore eu fugiat nulla pariatur.")
end

def tick args
 	if !args.state.start_new
       new_game(args)
    end

    args.outputs.solids << args.state.main_text.draw[:back]
	args.outputs.labels << args.state.main_text.draw[:labels]

	for b in args.state.main_text.tags do
		args.outputs.borders << b[:rect]
	end

	if args.inputs.mouse.click
		#print(" x:#{args.inputs.mouse.click.x} y: #{args.inputs.mouse.click.y}")
		for t in args.state.main_text.tags do
			if args.inputs.mouse.inside_rect? t[:rect]
				args.gtk.notify! "Link with tag #{t[:tag]}"
			end
		end
	end

	if args.inputs.keyboard.key_down.up
		args.state.main_text.scroll_up
	elsif args.inputs.keyboard.key_down.down
		args.state.main_text.scroll_down
	end
		
end
