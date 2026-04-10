mov $0x80, %al          # Put 0x80 into AL to configure the 8255 in Mode 0 (all outputs)
mov $0x643, %dx         # Store the control register address of the 8255 in DX
out %al, %dx            # Write the control value from AL into the control register

mov $300, %cx           # Set CX to 300 to determine duration of part 1

part1:                  # Beginning of part 1 display loop
    # S on dig-2
    mov $0x6D, %al      # Load AL with segment code corresponding to 'S'
    mov $0x642, %dx     # Point DX to Port B for segment data
    out %al, %dx        # Send segment pattern to display
    mov $0x03, %al      # Select digit position 2
    mov $0x641, %dx     # Point DX to Port A for digit control
    out %al, %dx        # Activate digit 2 to show 'S'
    call delay          # Wait briefly to keep digit visible
    # H on dig-1
    mov $0x76, %al      # Load AL with segment code for 'H'
    mov $0x642, %dx     # Address Port B again for segment output
    out %al, %dx        # Output pattern for 'H'
    mov $0x02, %al      # Choose digit position 1
    mov $0x641, %dx     # Address Port A for digit enable
    out %al, %dx        # Turn on digit 1 to display 'H'
    call delay          # Wait briefly to keep digit visible

    # E on dig-0
    mov $0x79, %al      # Load AL with segment pattern for 'E'
    mov $0x642, %dx     # Use Port B for segment signals
    out %al, %dx        # Send 'E' pattern to display
    mov $0x01, %al      # Select digit 0
    mov $0x641, %dx     # Use Port A for digit selection
    out %al, %dx        # Enable digit 0 to show 'E'
    call delay          # Wait briefly to keep digit visible

    loop part1          # Decrement CX and repeat part 1 until done

mov $300, %cx           # Reload CX for timing part 2

part2:                  # Start of part 2 shifting display
    # S on dig-3
    mov $0x6D, %al      # Segment encoding for 'S'
    mov $0x642, %dx     # Port B handles segment output
    out %al, %dx        # Display 'S'
    mov $0x04, %al      # Choose digit 3
    mov $0x641, %dx     # Port A controls digit selection
    out %al, %dx        # Activate digit 3
    call delay          # Wait briefly to keep digit visible

    # H on dig-2
    mov $0x76, %al      # Segment pattern for 'H'
    mov $0x642, %dx     # Send data to Port B
    out %al, %dx        # Display 'H'
    mov $0x03, %al      # Select digit 2
    mov $0x641, %dx     # Port A for digit enable
    out %al, %dx        # Turn on digit 2
    call delay          # Wait briefly to keep digit visible

    # E on dig-1
    mov $0x79, %al      # Segment encoding for 'E'
    mov $0x642, %dx     # Use Port B again
    out %al, %dx        # Display 'E'
    mov $0x02, %al      # Select digit 1
    mov $0x641, %dx     # Port A for digit control
    out %al, %dx        # Activate digit 1
    call delay          # Wait briefly to keep digit visible

    loop part2          # Continue until CX reaches zero

part3:                  # Final part where text stays shifted right
    # S on dig-4
    mov $0x6D, %al      # Load segment bits for 'S'
    mov $0x642, %dx     # Output goes to Port B
    out %al, %dx        # Show 'S'
    mov $0x05, %al      # Select digit 4
    mov $0x641, %dx     # Port A handles digit enabling
    out %al, %dx        # Activate digit 4
    call delay          # Wait briefly to keep digit visible

    # H on dig-3
    mov $0x76, %al      # Segment pattern for 'H'
    mov $0x642, %dx     # Port B for segment data
    out %al, %dx        # Display 'H'
    mov $0x04, %al      # Select digit 3
    mov $0x641, %dx     # Port A for digit select
    out %al, %dx        # Activate digit 3
    call delay          # Wait briefly to keep digit visible

    # E on dig-2
    mov $0x79, %al      # Segment bits for 'E'
    mov $0x642, %dx     # Send to Port B
    out %al, %dx        # Output 'E'
    mov $0x03, %al      # Choose digit 2
    mov $0x641, %dx     # Port A for enabling digit
    out %al, %dx        # Activate digit 2
    call delay          # Wait briefly to keep digit visible

    jmp part3           # Repeat part 3 indefinitely

delay:                  # Delay routine to slow down display refresh
    mov $300, %bx       # Initialize BX as loop counter
d1:                     # Inner loop for timing
    dec %bx             # Reduce BX by one each iteration
    jne d1              # Continue looping until BX reaches zero
    ret                 # Return control to caller
    