Simulations:
  - name: sim1
    time_integrator: ti_1
    optimizer: opt1

linear_solvers:

  - name: solve_scalar
    type: tpetra
    method: gmres
    preconditioner: sgs
    tolerance: 1e-5
    max_iterations: 50
    kspace: 50
    output_level: 0
    recompute_preconditioner: no
    
  - name: solve_cont
    type: tpetra
    method: gmres
    preconditioner: muelu
    tolerance: 1e-5
    max_iterations: 50
    kspace: 50
    output_level: 0
    recompute_preconditioner: no
    muelu_xml_file_name: xml/milestone.xml

realms:

  - name: realm_1
    mesh: abl_3km_256.g
    use_edges: yes
    automatic_decomposition_type: rcb

    equation_systems:
      name: theEqSys
      max_iterations: 2

      solver_system_specification:
        velocity: solve_scalar
        pressure: solve_cont
        enthalpy: solve_scalar

      systems:

        - LowMachEOM:
            name: myLowMach
            max_iterations: 1
            convergence_tolerance: 1e-5

        - Enthalpy:
            name: myEnth
            max_iterations: 1
            convergence_tolerance: 1e-5

    material_properties:

      target_name: Unspecified-2-HEX

      constant_specification:
       universal_gas_constant: 8314.4621
       reference_pressure: 101325.0

      reference_quantities:
        - species_name: Air
          mw: 29.0
          mass_fraction: 1.0

      specifications:
 
        - name: density
          type: constant
          value: 1.178037723

        - name: viscosity
          type: polynomial
          coefficient_declaration:
           - species_name: Air
             coefficients: [1.7894e-5, 273.11, 110.56]

        - name: specific_heat
          type: polynomial
          coefficient_declaration:
           - species_name: Air
             low_coefficients: [3.298677000E+00, 1.408240400E-03, -3.963222000E-06, 
                                5.641515000E-09, -2.444854000E-12,-1.020899900E+03]
             high_coefficients: [3.298677000E+00, 1.408240400E-03, -3.963222000E-06, 
                                 5.641515000E-09, -2.444854000E-12,-1.020899900E+03]

    initial_conditions:
      - constant: ic_1
        target_name: Unspecified-2-HEX
        value:
          pressure: 0
          temperature: 300.0
#          velocity: [10.0,0.0,0.0]

      - user_function: ic_2
        target_name: [Unspecified-2-HEX]
        user_function_name:
         velocity: boundary_layer_perturbation
        user_function_parameters:
         velocity: [0.5,0.012566370614359,0.020943951023932,50.0,10.0]

  
    boundary_conditions:

    - periodic_boundary_condition: bc_left_right
      target_name: [Front, Back]
      periodic_user_data:
        search_tolerance: 0.0001

    - periodic_boundary_condition: bc_front_back
      target_name: [Left, Right]
      periodic_user_data:
        search_tolerance: 0.0001 

    - open_boundary_condition: bc_open
      target_name: Top
      open_user_data:
        velocity: [10.0,0,0]
        pressure: 0.0
        temperature: 300.0

    - wall_boundary_condition: bc_lower
      target_name: Ground
      wall_user_data:
        velocity: [0,0,0]
        use_abl_wall_function: yes
        heat_flux: 0.0
        roughness_height: 0.01
        gravity_vector_component: 3
        reference_temperature: 300.0

    solution_options:
      name: myOptions
      turbulence_model: smagorinsky
      interp_rhou_together_for_mdot: yes

      options:

        - laminar_prandtl:
            enthalpy: 0.7

        - turbulent_prandtl:
            enthalpy: 1.0

        - source_terms:
            momentum: [buoyancy_boussinesq, EarthCoriolis]

        - user_constants:
            gravity: [0.0,0.0,-9.81]
            thermal_expansion_coefficient: 3.2e-3
            reference_density: 1.178037723
            reference_temperature: 300.0
            east_vector: [1.0, 0.0, 0.0]
            north_vector: [0.0, 1.0, 0.0]
            latitude: 44.0
            earth_angular_velocity: 7.2921159e-5

        - hybrid_factor:
            velocity: 0.0
            enthalpy: 1.0

        - limiter:
            pressure: no
            velocity: no
            enthalpy: yes 

        - peclet_function_form:
            velocity: tanh
            enthalpy: tanh

        - peclet_function_tanh_transition:
            velocity: 5000.0
            enthalpy: 2.01

        - peclet_function_tanh_width:
            velocity: 200.0
            enthalpy: 4.02

        - source_terms:
            momentum: body_force

        - source_term_parameters:
            momentum: [0.0, 1.193476931850350e-03, 0.0]


    output:
      output_data_base_name: output/abl_3km_256.e
      output_frequency: 100
      output_node_set: no
      output_variables:
       - velocity
       - pressure
       - specific_heat
       - viscosity

    restart:
      restart_data_base_name: restart/abl_3km_256.rst
      output_frequency: 500

Time_Integrators:
  - StandardTimeIntegrator:
      name: ti_1
      start_time: 0
      termination_step_count: 1000
      time_step: 1.5
      time_stepping_type: fixed
      time_step_count: 0
      second_order_accuracy: yes

      realms:
        - realm_1
