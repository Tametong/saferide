# Requirements Document

## Introduction

This specification addresses critical API integration issues between the Flutter ride-hailing application and its Laravel backend. The current implementation has mismatched endpoints, incorrect data structures, and missing functionality that prevents proper communication between the frontend and backend systems.

## Glossary

- **Flutter_App**: The mobile application client built with Flutter framework
- **Laravel_Backend**: The server-side API built with Laravel PHP framework
- **Datasource**: Flutter data layer component responsible for API communication
- **API_Endpoint**: A specific URL path and HTTP method combination for API requests
- **Response_Wrapper**: The data structure format used to wrap API responses
- **Passager**: French term for passenger/rider in the system
- **Chauffeur**: French term for driver in the system
- **Course**: French term for ride/trip in the system
- **Portefeuille**: French term for wallet in the system
- **OTP**: One-Time Password used for authentication verification

## Requirements

### Requirement 1: Authentication API Alignment

**User Story:** As a mobile app user, I want authentication to work correctly, so that I can register, login, and verify my account successfully.

#### Acceptance Criteria

1. WHEN the Laravel_Backend returns an otp_id as integer, THEN the Flutter_App SHALL parse it as an integer type
2. WHEN the Laravel_Backend returns user data as a single object, THEN the Flutter_App SHALL parse it as an object not an array
3. WHEN the Laravel_Backend does not return a token in register response, THEN the Flutter_App SHALL NOT expect a token field in the response
4. WHEN the Laravel_Backend does not return a token in verifyOtp response, THEN the Flutter_App SHALL handle authentication state without requiring a token from these endpoints
5. THE Flutter_App SHALL remove all references to non-existent resend-otp endpoint

### Requirement 2: Wallet API Endpoint Correction

**User Story:** As a passenger or driver, I want wallet operations to work correctly, so that I can view my balance, recharge, and see transaction history.

#### Acceptance Criteria

1. WHEN fetching wallet data, THE Flutter_App SHALL use POST request to `/passager/wallet/show` with `iduser` in request body
2. WHEN recharging wallet, THE Flutter_App SHALL use POST request to `/passager/wallet/recharge` with `iduser` and `montant` in request body
3. WHEN fetching wallet history, THE Flutter_App SHALL use GET request to `/passager/wallet/historique` with `iduser` as query parameter
4. WHEN the Laravel_Backend returns wallet data, THE Flutter_App SHALL parse the raw wallet object without expecting status/data wrapper
5. THE Flutter_App SHALL remove all references to GET `/portefeuille/{userId}` endpoint

### Requirement 3: Vehicle API Endpoint Correction

**User Story:** As a driver, I want vehicle management to work correctly, so that I can add, update, view, and delete my vehicles.

#### Acceptance Criteria

1. WHEN fetching driver vehicles, THE Flutter_App SHALL use GET request to `/chauffeur/vehicules/chauffeur/{id_chauffeur}`
2. WHEN creating a vehicle, THE Flutter_App SHALL use POST request to `/chauffeur/vehicules/` with vehicle data in request body
3. WHEN updating a vehicle, THE Flutter_App SHALL use PUT request to `/chauffeur/vehicules/{id_vehicule}` with updated data in request body
4. WHEN deleting a vehicle, THE Flutter_App SHALL use DELETE request to `/chauffeur/vehicules/{id_vehicule}`
5. WHEN the Laravel_Backend returns vehicle data, THE Flutter_App SHALL parse responses that may be wrapped in message/vehicule structure or returned as raw data

### Requirement 4: Driver API Endpoint Correction

**User Story:** As a passenger, I want to see available drivers correctly, so that I can book rides with accurate driver information.

#### Acceptance Criteria

1. WHEN fetching available drivers list, THE Flutter_App SHALL use GET request to `/passager/liste-chauffeurs`
2. WHEN fetching driver profile details, THE Flutter_App SHALL use GET request to `/chauffeur/profile/{id}`
3. WHEN updating driver location, THE Flutter_App SHALL use PATCH request to `/chauffeur/location/{id}` with location data in request body
4. WHEN the Laravel_Backend returns driver data, THE Flutter_App SHALL handle response structures that differ from the current expected format

### Requirement 5: Ride Management API Implementation

**User Story:** As a passenger, I want to create and manage rides, so that I can book transportation and cancel when needed.

#### Acceptance Criteria

1. WHEN creating and paying for a ride, THE Flutter_App SHALL use POST request to `/passager/coursepay` with id_passager, id_chauffeur, prix_en_points, id_admin, depart, and dest fields
2. WHEN canceling a ride, THE Flutter_App SHALL use POST request to `/passager/cancelcourse` with appropriate ride identification
3. THE Flutter_App SHALL send all required fields for ride creation as specified by Laravel_Backend
4. WHEN the Laravel_Backend returns ride data, THE Flutter_App SHALL parse the response structure correctly

### Requirement 6: Role-Based API Routing

**User Story:** As a system, I want API calls to use correct role-based prefixes, so that passengers and drivers access their respective endpoints.

#### Acceptance Criteria

1. WHEN a passenger makes wallet requests, THE Flutter_App SHALL use `/passager/wallet/*` endpoints
2. WHEN a driver makes wallet requests, THE Flutter_App SHALL use `/chauffeur/wallet/*` endpoints
3. WHEN a passenger requests driver list, THE Flutter_App SHALL use `/passager/liste-chauffeurs` endpoint
4. WHEN accessing driver-specific resources, THE Flutter_App SHALL use `/chauffeur/*` endpoints
5. THE Flutter_App SHALL determine the correct endpoint prefix based on authenticated user role

### Requirement 7: API Constants Update

**User Story:** As a developer, I want all API endpoint constants to be correct, so that the codebase uses accurate endpoint paths throughout.

#### Acceptance Criteria

1. THE Flutter_App SHALL define all authentication endpoints matching Laravel_Backend routes
2. THE Flutter_App SHALL define all wallet endpoints matching Laravel_Backend routes
3. THE Flutter_App SHALL define all vehicle endpoints matching Laravel_Backend routes
4. THE Flutter_App SHALL define all driver endpoints matching Laravel_Backend routes
5. THE Flutter_App SHALL define all ride endpoints matching Laravel_Backend routes
6. THE Flutter_App SHALL remove all non-existent endpoint constants

### Requirement 8: Data Model Alignment

**User Story:** As a developer, I want data models to match backend structures, so that serialization and deserialization work correctly.

#### Acceptance Criteria

1. WHEN parsing authentication responses, THE Flutter_App SHALL handle otp_id as integer type
2. WHEN parsing authentication responses, THE Flutter_App SHALL handle user as object not array
3. WHEN parsing wallet responses, THE Flutter_App SHALL handle raw wallet objects without status/data wrapper
4. WHEN parsing vehicle responses, THE Flutter_App SHALL handle both wrapped and unwrapped response formats
5. WHEN parsing any API response, THE Flutter_App SHALL use data models that match Laravel_Backend JSON structure

### Requirement 9: Datasource Implementation Updates

**User Story:** As a developer, I want all datasources to use correct API calls, so that data layer communicates properly with the backend.

#### Acceptance Criteria

1. THE Auth_Datasource SHALL implement all authentication methods using correct endpoints and data structures
2. THE Wallet_Datasource SHALL implement all wallet methods using correct endpoints and data structures
3. THE Vehicle_Datasource SHALL implement all vehicle methods using correct endpoints and data structures
4. THE Driver_Datasource SHALL implement all driver methods using correct endpoints and data structures
5. THE Ride_Datasource SHALL implement all ride methods using correct endpoints and data structures

### Requirement 10: End-to-End Functionality Validation

**User Story:** As a user, I want all app features to work correctly with the backend, so that I can use the ride-hailing service without errors.

#### Acceptance Criteria

1. WHEN a user completes registration flow, THE Flutter_App SHALL successfully communicate with Laravel_Backend through all steps
2. WHEN a user performs wallet operations, THE Flutter_App SHALL successfully execute all wallet transactions with Laravel_Backend
3. WHEN a driver manages vehicles, THE Flutter_App SHALL successfully perform all CRUD operations with Laravel_Backend
4. WHEN a passenger books a ride, THE Flutter_App SHALL successfully create the ride with Laravel_Backend
5. WHEN any API call is made, THE Flutter_App SHALL handle both success and error responses appropriately
