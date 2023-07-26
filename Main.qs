 namespace QuantumVariationalClassifier {

    operation AdvancedPhaseGate ( // The Qiskit P (PhaseGate) Gate is just an Rz gate. A lot of times in the circuit, we use it like this, however:
        qubit : Qubit,
        x : Double[],
        iOne : Int,
        iTwq : Int
    ) : Unit {
        Rz(2.0 * (PI() - x[iOne]) * (PI() - x[iTwo]));
    }

    operation ZZFeatureMap(qs : Qubit[], data : Double[]) : Unit {
    let numberOfQubits = Length(qs);
    if (numberOfQubits != Length(data)) {
        fail "Data length must be equal to the number of qubits.";
    }
    for i in 0..numberOfQubits-1 {
        // Apply Z rotation to each qubit
        Rz(2.0 * PI() * data[i], qs[i]);
    }
    for i in 0..numberOfQubits-1 {
        for j in i+1..numberOfQubits-1 {
            // Apply ZZ interaction between each pair of qubits
            let theta = 2.0 * PI() * data[i] * data[j];
            CNOT(qs[i], qs[j]);
            Rz(theta, qs[j]);
            CNOT(qs[i], qs[j]);
        }
    }
}

    //operation ZZFeatureMap ( // Stealing ZZFeatureMap from Qiskit, but for only specifically 4 values
        //register : Qubit[],
        //x : Double[]
    //) : Unit {

        // Variables and all to set up
        //let l = Length(register); // Will always be 4

        //let q0 = register[0];
        //let q1 = register[1];
        //let q2 = register[2];
        //let q3 = register[3];
        

        // Circuit:
        //ApplyToEach(H, register);

        //for i in (0 .. l-1) { 
            //Rz(2.0 * x[i], register[i]);
        //}

        //CNOT(q0, q1);

        //AdvancedPhaseGate(q1,x,0,1);

        //CNOT(q0,q1);
        //CNOT(q0,q2);

        //AdvancedPhaseGate(q2,x,0,2);

        //CNOT(q0,q2);
        //CNOT(q0,q3);

        //CNOT(q1,q2);
        //AdvancedPhaseGate(q3,x,0,3);

        //AdvancedPhaseGate(q2,x,1,2);

        //CNOT(q0,q3);
        //CNOT(q1,q2);
        //CNOT(q1,q3);

        //AdvancedPhaseGate(q3,x,1,3);

        //CNOT(q1,q3);
        //CNOT(q2,q3);

        //AdvancedPhaseGate(q3,x,2,3);

        //CNOT(q2,q3);
    //}   

     operation ZFeatureMap ( // Stealing ZFeatureMap from Qiskit, for ANY number for values
        register : Qubit[],
        x : Double[]
    ) : Unit {
        ApplyToEach(H, register);

        for i in (0 .. l-1) { 
            Rz(2.0 * x[i], register[i]);
        }
    }


    operation RealAmplitudes(qubits : Qubit[], parameters : Double[]) : Unit {
        // Apply layer of rotation gates
        for idx in IndexRange(qubits) {
            Ry(parameters[idx], qubits[idx]);
        }

        // Apply a layer of CNOT gates
        for idx in 0 .. Length(qubits)-2 {
            for i in idx+1 .. Length(qubits)-1{
                CNOT(qubits[idx], qubits[i]);
            }
        }


        // Apply another layer of rotation gates
        for idx in IndexRange(qubits) {
            Ry(parameters[idx + Length(qubits)], qubits[idx]);
        }
    }

    operation quantumVariationalClassifier (qubits: Qubit[], x : Double[], θ : Double[]) : Unit {
        ZZFeatureMap(qubits, x);
        RealAmplitudes(qubits, θ);
    }

    // MEAN SQUARED ERROR OPERATION IS REMOVED, SINCE MSE CALCULATION CAN BE OPTIMIZED BETTER WITHOUT IT
    // operation meanSquaredError(guesses : Double[], answers : Double[]) : Double { // For our case, answers should be a boolean array converted to a double array
        
    //     // Our program supports the answer list being longer than the guesses, by the way
    
    //     let l = Length(guesses);
        
    //     mutable sumOfSquaredErrors = 0.0;

    //     for i in (0 .. l-1) {
    //         let error = guesses[i] - answers[i]; // Order doesn't matter, since the difference will be squared
    //         let squaredError = (error ^ 2);

    //         set sumOfSquaredErrors += squaredError;
    //     }

    //     return sumOfSquaredErrors / IntAsDouble(l);

    // }

    // iterations would be how many times the algorithms cycles through all of the training data
    operation doMachineLearning (trainingData : Double[][], trainingAnswers : Double[], iterations : Int, numTimesToRunQVCForProbabilityEstimation : Int) : Unit { // For our case, trainingAnswers should be a boolean array converted to a double array
        
        let dimensions = Length(trainingData[0]); // The number of data points for each penguin (as of writing this, this is 4)
        
        mutable parameters = [0.0, size = (2*dimensions) ]; // This is θ (theta)

        mutable sumOfSquaredErrors = 0.0;
        mutable numOfSquaredErrors = 0;
        for iteration in (1 .. iterations) { // Not to be confused with index

            for i in IndexRange(trainingData) {

                let penguinData = trainingData[i]; 

                

                // Run QVC and read its output:
                mutable numOnes = 0;
                for qvcRepetitions in (1 .. numTimesToRunQVCForProbabilityEstimation) {
                    use qubits = Qubit[dimensions];

                    quantumVariationalClassifier(qubits, penguinData, parameters);

                    let bitstring = ResultArrayAsBoolArray(MultiM(qubits));

                    let parityBit = bitstring[dimensions-1]; // Parity bit just means the last bit. This is essentially the output of our QVC

                    if parityBit {
                        set numOnes += 1;
                    }
                }

                let probabilityOfOne = IntAsDouble(numOnes) / IntAsDouble(numTimesToRunQVCForProbabilityEstimation);



                // Mean Squared Error Calculation:
                let error = probabilityOfOne - trainingAnswers[i]; // Order doesn't matter, since the difference will be squared
                let squaredError = (error ^ 2.0);

                set sumOfSquaredErrors += squaredError;
                set numOfSquaredErrors += 1;

                let meanSquaredError = sumOfSquaredErrors / IntAsDouble(numOfSquaredErrors);
                Message("MSE: " + DoubleAsString(meanSquaredError));



                // INSERT OPTIMIZER SHTUFF HERE
            
            }
        }
    }
}