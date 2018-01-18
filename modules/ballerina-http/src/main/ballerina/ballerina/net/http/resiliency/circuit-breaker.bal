package ballerina.net.http.resiliency;

import ballerina.net.http;

enum CircuitState {
    OPEN, CLOSE, HALF_OPEN
}

struct CircuitHealth {
    float requestCount;
    float errorCount;
    Time lastErrorTime;
}

public connector CircuitBreaker (http:HttpClient httpClient, float failurePercentageThreshold, int resetTimeout) {

    endpoint<http:HttpClient> httpEP {
        httpClient;
    }

    CircuitHealth circuitHealth = {};
    // TODO: once enum init inside a struct is do-able, move this inside circuitHealth (issue #4340)
    CircuitState currentState = CircuitState.CLOSE;

    action post (string path, http:Request request) (http:Response, http:HttpConnectorError) {
        currentState = updateCircuitState(circuitHealth, currentState, failurePercentageThreshold, resetTimeout);
        http:Response response;
        http:HttpConnectorError err;

        if (currentState == CircuitState.OPEN) {
            // TODO: Allow the user to handle this scenario. Maybe through a user provided function
            response = handleOpenCircuit(circuitHealth, resetTimeout);
        } else {
            response, err = httpEP.post(path, request);
            updateCircuitHealth(circuitHealth, err);
        }

        return response, err;
    }

    action head (string path, http:Request request) (http:Response, http:HttpConnectorError) {
        currentState = updateCircuitState(circuitHealth, currentState, failurePercentageThreshold, resetTimeout);
        http:Response response;
        http:HttpConnectorError err;

        if (currentState == CircuitState.OPEN) {
            // TODO: Allow the user to handle this scenario. Maybe through a user provided function
            response = handleOpenCircuit(circuitHealth, resetTimeout);
        } else {
            response, err = httpEP.head(path, request);
            updateCircuitHealth(circuitHealth, err);
        }

        return response, err;
    }

    action put (string path, http:Request request) (http:Response, http:HttpConnectorError) {
        currentState = updateCircuitState(circuitHealth, currentState, failurePercentageThreshold, resetTimeout);
        http:Response response;
        http:HttpConnectorError err;

        if (currentState == CircuitState.OPEN) {
            // TODO: Allow the user to handle this scenario. Maybe through a user provided function
            response = handleOpenCircuit(circuitHealth, resetTimeout);
        } else {
            response, err = httpEP.put(path, request);
            updateCircuitHealth(circuitHealth, err);
        }

        return response, err;
    }

    action execute (string httpVerb, string path, http:Request request) (http:Response, http:HttpConnectorError) {
        currentState = updateCircuitState(circuitHealth, currentState, failurePercentageThreshold, resetTimeout);
        http:Response response;
        http:HttpConnectorError err;

        if (currentState == CircuitState.OPEN) {
            // TODO: Allow the user to handle this scenario. Maybe through a user provided function
            response = handleOpenCircuit(circuitHealth, resetTimeout);
        } else {
            response, err = httpEP.execute(httpVerb, path, request);
            updateCircuitHealth(circuitHealth, err);
        }

        return response, err;
    }

    action patch (string path, http:Request request) (http:Response, http:HttpConnectorError) {
        currentState = updateCircuitState(circuitHealth, currentState, failurePercentageThreshold, resetTimeout);
        http:Response response;
        http:HttpConnectorError err;

        if (currentState == CircuitState.OPEN) {
            // TODO: Allow the user to handle this scenario. Maybe through a user provided function
            response = handleOpenCircuit(circuitHealth, resetTimeout);
        } else {
            response, err = httpEP.patch(path, request);
            updateCircuitHealth(circuitHealth, err);
        }

        return response, err;
    }

    action delete (string path, http:Request request) (http:Response, http:HttpConnectorError) {
        currentState = updateCircuitState(circuitHealth, currentState, failurePercentageThreshold, resetTimeout);
        http:Response response;
        http:HttpConnectorError err;

        if (currentState == CircuitState.OPEN) {
            // TODO: Allow the user to handle this scenario. Maybe through a user provided function
            response = handleOpenCircuit(circuitHealth, resetTimeout);
        } else {
            response, err = httpEP.delete(path, request);
            updateCircuitHealth(circuitHealth, err);
        }

        return response, err;
    }

    action options (string path, http:Request request) (http:Response, http:HttpConnectorError) {
        currentState = updateCircuitState(circuitHealth, currentState, failurePercentageThreshold, resetTimeout);
        http:Response response;
        http:HttpConnectorError err;

        if (currentState == CircuitState.OPEN) {
            // TODO: Allow the user to handle this scenario. Maybe through a user provided function
            response = handleOpenCircuit(circuitHealth, resetTimeout);
        } else {
            response, err = httpEP.options(path, request);
            updateCircuitHealth(circuitHealth, err);
        }

        return response, err;
    }

    action forward (string path, http:Request request) (http:Response, http:HttpConnectorError) {
        currentState = updateCircuitState(circuitHealth, currentState, failurePercentageThreshold, resetTimeout);
        http:Response response;
        http:HttpConnectorError err;

        if (currentState == CircuitState.OPEN) {
            // TODO: Allow the user to handle this scenario. Maybe through a user provided function
            response = handleOpenCircuit(circuitHealth, resetTimeout);
        } else {
            response, err = httpEP.forward(path, request);
            updateCircuitHealth(circuitHealth, err);
        }

        return response, err;
    }

    action get (string path, http:Request request) (http:Response, http:HttpConnectorError) {
        currentState = updateCircuitState(circuitHealth, currentState, failurePercentageThreshold, resetTimeout);
        http:Response response;
        http:HttpConnectorError err;

        if (currentState == CircuitState.OPEN) {
            // TODO: Allow the user to handle this scenario. Maybe through a user provided function
            response = handleOpenCircuit(circuitHealth, resetTimeout);
        } else {
            response, err = httpEP.get(path, request);
            updateCircuitHealth(circuitHealth, err);
        }

        return response, err;
    }
}

function updateCircuitState (CircuitHealth circuitHealth, CircuitState currentState, float failureThreshold,
                             int resetTimeout) (CircuitState) {
    if (currentState == CircuitState.OPEN) {
        Time currentT = currentTime();
        int elapsedTime = currentT.time - circuitHealth.lastErrorTime.time;

        if (elapsedTime > resetTimeout) {
            circuitHealth.errorCount = 0;
            circuitHealth.requestCount = 0;
            currentState = CircuitState.HALF_OPEN;
        }
    } else if (currentState == CircuitState.HALF_OPEN) {
        if (circuitHealth.errorCount > 0) {
            // If the trial run has failed, trip the circuit again
            currentState = CircuitState.OPEN;
        } else {
            // If the trial run was successful reset the circuit
            currentState = CircuitState.CLOSE;
        }
    } else {
        float currentFailureRate = 0;

        if (circuitHealth.requestCount > 0) {
            currentFailureRate = (circuitHealth.errorCount / circuitHealth.requestCount) * 100;
        }

        if (currentFailureRate > failureThreshold) {
            currentState = CircuitState.OPEN;
        }
    }

    return currentState;
}

function updateCircuitHealth(CircuitHealth circuitHealth, http:HttpConnectorError err) {
    circuitHealth.requestCount = circuitHealth.requestCount + 1;

    if (err != null) {
        circuitHealth.errorCount = circuitHealth.errorCount + 1;
        circuitHealth.lastErrorTime = currentTime();
    }
}

function createErrorResponse (string msg, int statusCode) (http:Response) {
    http:Response errorResponse = {};
    errorResponse.setStringPayload(msg);
    errorResponse.setStatusCode(statusCode);
    return errorResponse;
}

function handleOpenCircuit (CircuitHealth circuitHealth, int resetTimeout) (http:Response) {
    Time currentT = currentTime();
    int timeDif = currentT.time - circuitHealth.lastErrorTime.time;
    int timeRemaining = resetTimeout - timeDif;
    return createErrorResponse("Upstream service unavailable. Requests to upstream service will be suspended for "
                               + timeRemaining + " milliseconds", 503);
}
