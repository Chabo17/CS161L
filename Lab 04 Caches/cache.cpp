//=========================================================================
// Name & Email must be EXACTLY as in Gradescope roster!
// Name: Alex Nguyen Chandler Bottomley
// Email: anguy258@ucr.edu cbott001@ucr.edu
// 
// Assignment name: Lab 4
// Lab section: 021
// TA: Sakib Malek
// 
// I hereby certify that I have not received assistance on this assignment,
// or used code, from ANY outside source other than the instruction team
// (apart from what was provided in the starter file).
//
//=========================================================================

#include <iostream>
#include <iomanip> // for setprecision()
#include <vector>
#include <math.h> // for log2()
#include <algorithm> // for find() to find misses
#include <sstream> // for stringstream

using namespace std;

static const size_t BLOCK_SIZE = 16;
static const size_t CACHE_SIZE = 16384;

struct data {
  vector<unsigned long long> time;
  vector<unsigned long long> tag;
};

unsigned long long Offset(int temp) { // find index offset
  unsigned long long offset = 1;
  for (int i = 1; i < temp; ++i) {
    offset = (offset << 1) + 1;
  }
  return offset;
}

int LRU_offset (vector<unsigned long long> time) { // find LRU policy offset
  unsigned long long min = 180000000000000000;
  int tmp = 0;
  
  for (unsigned int i = 0; i < time.size(); ++i) {
    if (min > time[i]) {
      tmp = i;
      min = time[i];
    }
  }
  return tmp;
}
unsigned long long lines[10000000];
unsigned long long inputs = 0;

double miss_rate (unsigned int ass, int cacheSize, int policy) {  // find miss rate
    unsigned long long curr_time = 1;
    unsigned long long read_line;
    int num_blocks = cacheSize / BLOCK_SIZE / ass; 
    int offset = (int)log2(BLOCK_SIZE); 
    int indexSize = (int)log2(num_blocks);
    int total = 0;
    int miss = 0;
    
    data cache[num_blocks];
    
    for (int line_index = 0; line_index <= inputs; ++line_index, ++total) {
      read_line = lines[line_index];
      unsigned long long tag = read_line >> (indexSize + offset); // get tag
      unsigned long long index = read_line >> offset; // get index

      index = index & Offset(indexSize);
      vector<unsigned long long>::const_iterator it;
      it = find(cache[index].tag.begin(), cache[index].tag.end(), tag); // find matching tags at index
      if (it == cache[index].tag.end()) { // check if iterator reaches end i.e. tag not found
        ++miss;
        cache[index].tag.push_back(tag);
        cache[index].time.push_back(curr_time++);
        if  (cache[index].tag.size() > ass) {
          if (policy) { // FIFO if policy is 1 
            cache[index].tag.erase(cache[index].tag.begin());
            cache[index].time.erase(cache[index].time.begin());
          }
          else {  // LRU if policy is 0 
            int temp_lru = LRU_offset(cache[index].time);
            cache[index].tag.erase(cache[index].tag.begin() + temp_lru);
            cache[index].time.erase(cache[index].time.begin() + temp_lru);
          }
        }
      }
      else {
        int time_index = it - cache[index].tag.begin();
        cache[index].time[time_index] = curr_time++;
      }
   }
   return (double)miss / total;
}

int main(int argc, char* argv[]) {
    int ass;
    int cacheSize;
    int policy = 0;

    while(std::cin >> std::hex >> lines[inputs++]);
    stringstream INT (argv[1]);
    INT >> ass;
    stringstream INTER (argv[2]);
    INTER >> cacheSize;

    if (argc < 4) {
      cout << "Not Enough Inputs..." << endl;
    }
    else if (argc > 4) {
      cout << "Too Many Inputs..." << endl;
    }

    string FIFO = "FIFO";
    string LRU = "LRU";

    if (string(argv[3]) == FIFO) {
      policy = 1;
    }
    else if (string(argv[3]) == LRU) {
      policy = 0;
    }
    else {
      cout << "Invalid Policy..." << endl;
      return 0;
    }
    
    if (cacheSize % 1024 != 0 && cacheSize > 16384){
      cout << "Invalid Cache Size..." << endl;
      return 0;
    }

    std::cout << "associativity:      " << ass << std::endl;
    std::cout << "cache size:         " << cacheSize << std::endl;
    std::cout << "replacement policy: " << argv[3] << std::endl;
    std::cout << "miss rate:          " << std::fixed << std::setprecision(2) <<  (miss_rate(ass, cacheSize, policy) * 100.0) << std::endl;
    

    return 0;
}