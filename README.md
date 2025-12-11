# ULX3S-Playground
Messing around with the ULX3S and open source tools!

# Goals
This is a project meant to get affiliated with some open source tooling that has been gaining
traction recently, such as ``yosys``, ``Verilator``, and ``nextpnr``. I was also able to grab a ``ULX3S`` from
Professor Bill Nace (shoutout 18-224), which has pretty good support. The specific part number I am
currently working with is the ``LFE5U-12F-6BG381C``, which has 12K LUTs, and more than enough I/O
for the projects I aim to use this FPGA for.

# Setup
Unfortunately, ``nextpnr`` and more specifically, Project Trellis do not work well with more recent Macs. Specifically,
when building Project Trellis from source, I kept running into an issue with the ``C++ boost`` library, and more
accurately, the specific filenames certain imports were looking for (issues with multithreading introduced into the C++
boost library). To make things easier, I am running an Ubuntu Docker container with Rosetta 2 for ``x86`` translation.
It introduces some (read: a lot of) overhead when trying to build all of the tooling from source, but it doesn't seem to be too much of
an issue when actually running ``yosys`` and ``nextpnr`` for synthesis and PnR.

Currently, the files in this repo include two toy examples provided by Project Trellis, and a Makefile just to set up the bare bones
of an environment where I can synthesize and route larger designs in the future. A couple of things to keep in mind, though, are that
there a lot of conflicting Makefiles/information online about how to correctly run ``nextpnr`` on designs for the ``12F`` version
of this FPGA.

First, instead of defining pins manually in the Verilog to be recognized by the tooling, use an ``LPF`` file. This file is a lightweight
format and in this case, it is used to describe signals and their corresponding pins on the ``ULX3S``. This simplifies things a bunch and
makes it pretty easy to get started. Second, the ``12F`` version of the ``ECP5`` Lattice FPGA has 12K LUTs, not 25K LUTs; at least this is the case at the time that this is written. Finally, when providing the package to ``nextpnr``, check the Lattice website. The package
I am currently working with is the CABGA381. This is just a description of the packaging of the chip itself, but is still important.

# Communications
Communications with an external computer are achieved through UART and an FTDI to USB bridge present on the ULX3S. Currently, UART_TX from the ULX3S is implemented, once I get a good enough usecase for this board, I'll implement UART_RX to send data from an external computer.
Only annoying thing about this was that the output had to be to the FTDI_RX pin (as the FTDI bridge is what is performing the translation). This is also mentioned in the LPF; reading documentation seems to be an important skill. 
