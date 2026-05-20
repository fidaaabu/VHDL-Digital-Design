
1. Adder.vhd (Arithmetic Component)
Performs the single adder-based arithmetic required for condition checking.
Used as a single instantiation within the top-level design to minimize hardware usage.

2. aux_package.vhd (Auxiliary Package)
Contains shared component declarations and necessary type definitions.
Ensures consistent structural definitions and interfaces across the design modules.

3. top.vhd (System Top Entity)
Integrates the synchronous digital system into a structural design for valid sub-series detection.
Process 1 (Two-sample array): Samples the input vector $x$ to maintain the current and previous values, x[j-1] and x[j-2].
Process 2 (Condition Logic): Employs the Adder to calculate $diff = x[j-1] - x[j-2] and determines if the result matches the selected DetectionCode.
Process 3 (Sequence Detector): Monitors valid triggers and asserts the detector output if more than $m$ valid elements are detected in a row.
