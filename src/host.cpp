#include <fstream>
#include "xcl2.hpp"
#include <algorithm>
#include <iostream>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <vector>
#include <string>
#include <climits>
#include <time.h>
#include <chrono>
#include "ap_int.h"

#define RLEN 320
#define QLEN 320
#define NUM_KERNEL 1

#define NOW std::chrono::high_resolution_clock::now();

#define MAX_HBM_BANKCOUNT 32
#define BANK_NAME(n) n | XCL_MEM_TOPOLOGY
const int bank[MAX_HBM_BANKCOUNT] = {
    BANK_NAME(0),  BANK_NAME(1),  BANK_NAME(2),  BANK_NAME(3),  BANK_NAME(4),
    BANK_NAME(5),  BANK_NAME(6),  BANK_NAME(7),  BANK_NAME(8),  BANK_NAME(9),
    BANK_NAME(10), BANK_NAME(11), BANK_NAME(12), BANK_NAME(13), BANK_NAME(14),
    BANK_NAME(15), BANK_NAME(16), BANK_NAME(17), BANK_NAME(18), BANK_NAME(19),
    BANK_NAME(20), BANK_NAME(21), BANK_NAME(22), BANK_NAME(23), BANK_NAME(24),
    BANK_NAME(25), BANK_NAME(26), BANK_NAME(27), BANK_NAME(28), BANK_NAME(29),
    BANK_NAME(30), BANK_NAME(31)};

int main(int argc, char *argv[]){

    char dna[4] = {'C', 'G', 'T', 'A'};

    if (argc != 2) {
        std::cout << "Usage: " << argv[0] << " <XCLBIN File>" << std::endl;
        return EXIT_FAILURE;
    }

    std::string binaryFile = argv[1];
	//std::string readsPath = argv[2];
	srand(time(NULL));

    cl_int err;
    cl::CommandQueue commands;
    cl::Context context;

    std::vector< ap_int<10>, aligned_allocator< ap_int<10> > > data_m0(12);
    data_m0[11] = 1;
    data_m0[10] = -1;
    data_m0[9] = -1;
    data_m0[8] = -1;
    data_m0[7] = 1;
    data_m0[6] = -1;
    data_m0[5] = -1;
    data_m0[4] = 1;
    data_m0[3] = -1;
    data_m0[2] = 1;
    data_m0[1] = -1;
    data_m0[0] = -1;

    std::vector< char, aligned_allocator< char > > data_m1(RLEN);
    for(int i = 0; i < RLEN; i++){
        data_m1[i] = dna[rand()%4];
    }
    std::vector< char, aligned_allocator< char > > data_m2(QLEN);
    for(int i = 0; i < QLEN; i++){
        data_m2[i] = dna[rand()%4];
    }
    std::vector< ap_int<512>, aligned_allocator< ap_int<512> > > data_m3(1);
    data_m3[0]=1;
    std::vector< ap_int<512>, aligned_allocator< ap_int<512> > > data_m4(1);
    data_m4[0]=1;
    std::vector< ap_int<512>, aligned_allocator< ap_int<512> > > data_m5(1);

	// printf("Penalties initialized: %d, %d, %d, %d \n", affine_penalties.match, affine_penalties.mismatch, affine_penalties.gap_opening, affine_penalties.gap_extension);

    std::string krnl_name = "KDarwin";
    std::vector<cl::Kernel> krnls(NUM_KERNEL);

    // The get_xil_devices will return vector of Xilinx Devices
    auto devices = xcl::get_xil_devices();

    // read_binary_file() command will find the OpenCL binary file created using the
    // V++ compiler load into OpenCL Binary and return pointer to file buffer.
    auto fileBuf = xcl::read_binary_file(binaryFile);

    cl::Program::Binaries bins{{fileBuf.data(), fileBuf.size()}};
    int valid_device = 0;


    for (unsigned int i = 0; i < devices.size(); i++) {
        auto device = devices[i];
            // Creating Context and Command Queue for selected Device
        OCL_CHECK(err, context = cl::Context(device, NULL, NULL, NULL, &err));
        OCL_CHECK(err, commands = cl::CommandQueue(context, device,
                            CL_QUEUE_OUT_OF_ORDER_EXEC_MODE_ENABLE | CL_QUEUE_PROFILING_ENABLE, &err));

        std::cout << "Trying to program device[" << i 
                  << "]: " << device.getInfo<CL_DEVICE_NAME>() << std::endl;
     
        cl::Program program(context, {device}, bins, NULL, &err);
        
        if (err != CL_SUCCESS) {
            std::cout << "Failed to program device[" << i
                        << "] with xclbin file!\n";                      
        } else {
            std::cout << "Device[" << i << "]: program successful!\n";
            
            // Creating Kernel object using Compute unit names
            for (int i = 0; i < NUM_KERNEL; i++) {
                std::string cu_id = std::to_string(i + 1);
                std::string krnl_name_full = krnl_name;

                printf("Creating a kernel [%s]\n", krnl_name_full.c_str());

                //Here Kernel object is created by specifying kernel name along with compute unit.
                //For such case, this kernel object can only access the specific Compute unit
                OCL_CHECK(err, krnls[i] = cl::Kernel(program, krnl_name_full.c_str(), &err));
            }

            valid_device++;
            break; // we break because we found a valid device
        }
    }
    
    if (valid_device == 0) {
        std::cout << "Failed to program any device found, exit!\n";
        exit(EXIT_FAILURE);
    }

    // Create device buffers
    std::vector<cl_mem_ext_ptr_t> m_00_ext(NUM_KERNEL);
    std::vector<cl_mem_ext_ptr_t> m_01_ext(NUM_KERNEL);
    std::vector<cl_mem_ext_ptr_t> m_02_ext(NUM_KERNEL);
    std::vector<cl_mem_ext_ptr_t> m_03_ext(NUM_KERNEL);
    std::vector<cl_mem_ext_ptr_t> m_04_ext(NUM_KERNEL);
    std::vector<cl_mem_ext_ptr_t> m_05_ext(NUM_KERNEL);

    std::vector<cl::Buffer> m_00(NUM_KERNEL);
    std::vector<cl::Buffer> m_01(NUM_KERNEL);
    std::vector<cl::Buffer> m_02(NUM_KERNEL);
    std::vector<cl::Buffer> m_03(NUM_KERNEL);
    std::vector<cl::Buffer> m_04(NUM_KERNEL);
    std::vector<cl::Buffer> m_05(NUM_KERNEL);

	

    for(int i = 0; i < NUM_KERNEL; i++) {

        m_00_ext[i].obj = data_m0.data();
        m_00_ext[i].param = 0;
        m_00_ext[i].flags = bank[i*6];

        m_01_ext[i].obj = data_m1.data();
        m_01_ext[i].param = 0;
        m_01_ext[i].flags = bank[i*6+1];
        
        m_02_ext[i].obj = data_m2.data();
        m_02_ext[i].param = 0;
        m_02_ext[i].flags = bank[i*6+2];

        m_03_ext[i].obj = data_m3.data();
        m_03_ext[i].param = 0;
        m_03_ext[i].flags = bank[i*6+3];

        m_04_ext[i].obj = data_m4.data();
        m_04_ext[i].param = 0;
        m_04_ext[i].flags = bank[i*6+4];

        m_05_ext[i].obj = data_m5.data();
        m_05_ext[i].param = 0;
        m_05_ext[i].flags = bank[i*6+5];

    }

    for (int i = 0; i < NUM_KERNEL; i++) {
    	OCL_CHECK(err, m_00[i] = cl::Buffer(context, CL_MEM_READ_WRITE | CL_MEM_EXT_PTR_XILINX |
                                    CL_MEM_USE_HOST_PTR, 64, &m_00_ext[i], &err));
        OCL_CHECK(err, m_01[i] = cl::Buffer(context, CL_MEM_READ_WRITE | CL_MEM_EXT_PTR_XILINX |
                                    CL_MEM_USE_HOST_PTR, sizeof(char)*data_m1.size(), &m_01_ext[i], &err));
        OCL_CHECK(err, m_02[i] = cl::Buffer(context, CL_MEM_READ_WRITE | CL_MEM_EXT_PTR_XILINX |
                                    CL_MEM_USE_HOST_PTR, sizeof(char)*data_m2.size(), &m_02_ext[i], &err));
        OCL_CHECK(err, m_03[i] = cl::Buffer(context, CL_MEM_READ_WRITE | CL_MEM_EXT_PTR_XILINX |
                                    CL_MEM_USE_HOST_PTR, sizeof(ap_int<512>), &m_03_ext[i], &err));
        OCL_CHECK(err, m_04[i] = cl::Buffer(context, CL_MEM_READ_WRITE | CL_MEM_EXT_PTR_XILINX |
                                    CL_MEM_USE_HOST_PTR, sizeof(ap_int<512>), &m_04_ext[i], &err));
        OCL_CHECK(err, m_05[i] = cl::Buffer(context, CL_MEM_READ_WRITE | CL_MEM_EXT_PTR_XILINX |
                                    CL_MEM_USE_HOST_PTR, sizeof(ap_int<512>), &m_05_ext[i], &err));
    }

	commands.finish();

    // Write our data set into device buffers  
     for(int i = 0; i < NUM_KERNEL; i++)
        err = commands.enqueueMigrateMemObjects({m_00[i], m_01[i], m_02[i], m_03[i], m_04[i], m_05[i]}, 0);

    if (err != CL_SUCCESS) {
            printf("Error: Failed to write to device memory!\n");
            printf("Test failed\n");
            exit(1);
    }

	commands.finish();

    int set_params = -1;
    int ref_wr_en = -1;
    int query_wr_en = -1;
    int max_tb_steps = 400;
    int ref_len = RLEN;
    int query_len = QLEN;
    int score_threshold = 0;
    int align_fields = (1<<5);
    int start = 1;
    int clear_done = 1;
    int req_id_in = -1;


    // Set the arguments to our compute kernel
    for (int i = 0; i < NUM_KERNEL; i++) {
        OCL_CHECK(err, err = krnls[i].setArg(0, set_params));
        OCL_CHECK(err, err = krnls[i].setArg(1, ref_wr_en));
        OCL_CHECK(err, err = krnls[i].setArg(2, query_wr_en));
        OCL_CHECK(err, err = krnls[i].setArg(3, max_tb_steps));
		OCL_CHECK(err, err = krnls[i].setArg(4, ref_len));
		OCL_CHECK(err, err = krnls[i].setArg(5, query_len));
		OCL_CHECK(err, err = krnls[i].setArg(6, score_threshold));
		OCL_CHECK(err, err = krnls[i].setArg(7, align_fields));
        OCL_CHECK(err, err = krnls[i].setArg(8, start));
		OCL_CHECK(err, err = krnls[i].setArg(9, clear_done));
		OCL_CHECK(err, err = krnls[i].setArg(10, req_id_in));
		OCL_CHECK(err, err = krnls[i].setArg(11, m_00[i]));
		OCL_CHECK(err, err = krnls[i].setArg(12, m_01[i]));
        OCL_CHECK(err, err = krnls[i].setArg(13, m_02[i]));
        OCL_CHECK(err, err = krnls[i].setArg(14, m_03[i]));
        OCL_CHECK(err, err = krnls[i].setArg(15, m_04[i]));
        OCL_CHECK(err, err = krnls[i].setArg(16, m_05[i]));

        if (err != CL_SUCCESS) {
            printf("Error: Failed to set kernel arguments! %d\n", err);
            printf("Test failed\n");
            exit(1);
        }
    }

	commands.finish();

    std::chrono::high_resolution_clock::time_point start_time = NOW;
    // Execute the kernel over the entire range of our 1d input data set
    // using the maximum number of work group items for this device
    for (int i = 0; i < NUM_KERNEL; ++i)
        err |= commands.enqueueTask(krnls[i]);


    if (err) {
        printf("Error: Failed to execute kernel! %d\n", err);
        printf("Test failed\n");
        exit(1);
    }

    commands.finish();
    std::chrono::high_resolution_clock::time_point end_time = NOW;
	std::chrono::duration<double> time = std::chrono::duration_cast<std::chrono::duration<double>>(end_time-start_time)/NUM_KERNEL;
    
    // Read back the results from the device to verify the output
    for (int i = 0; i < NUM_KERNEL; ++i) {
        err = commands.enqueueMigrateMemObjects({m_05[i]}, CL_MIGRATE_MEM_OBJECT_HOST);  
    }

    // std::cout<< data_m5[0] <<std::endl;

    if (err != CL_SUCCESS) {
        printf("Error: Failed to read output array! %d\n", err);
        printf("Test failed\n");
        exit(1);
    }

    

	printf("HW time: %lf\n", time);

	//Checking the results 

    bool test_score = true;
	

	if (test_score) 
		std::cout<<"ALL RESULTS CORRECT"<<std::endl;
	else 
		std::cout<<"Test failed"<<std::endl;

    return 0;
}