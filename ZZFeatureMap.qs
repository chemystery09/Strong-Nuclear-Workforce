namespace QuantumVariationalClassifier {

    operation AdvancedPhaseGate ( // The Qiskit P (PhaseGate) Gate is just an Rz gate. A lot of times in the circuit, we use it like this, however:
        qubit : Qubit,
        x : Double[],
        iOne : Int,
        iTwq : Int
    ) : Unit {
        Rz(2.0 * (PI() - x[iOne]) * (PI() - x[iTwo]));
    }

    operation ZZFeatureMap ( // Stealing ZZFeatureMap from Qiskit, but for only specifically 4 values
        register : Qubit[],
        x : Double[]
    ) : Unit {

        // Variables and all to set up
        let l = Length(register); // Will always be 4

        let q0 = register[0];
        let q1 = register[1];
        let q2 = register[2];
        let q3 = register[3];
        

        // Circuit:
        ApplyToEach(H, register);

        for i in (0 .. l-1) { 
            Rz(2.0 * x[i], register[i]);
        }

        CNOT(q0, q1);

        AdvancedPhaseGate(q1,x,0,1);

        CNOT(q0,q1);
        CNOT(q0,q2);

        AdvancedPhaseGate(q2,x,0,2);

        CNOT(q0,q2);
        CNOT(q0,q3);

        CNOT(q1,q2);
        AdvancedPhaseGate(q3,x,0,3);

        AdvancedPhaseGate(q2,x,1,2);

        CNOT(q0,q3);
        CNOT(q1,q2);
        CNOT(q1,q3);

        AdvancedPhaseGate(q3,x,1,3);

        CNOT(q1,q3);
        CNOT(q2,q3);

        AdvancedPhaseGate(q3,x,2,3);

        CNOT(q2,q3);
    }   
}