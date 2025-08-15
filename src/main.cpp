#include <fstream>
#include <csignal>
#include <functional>
#include <atomic>

#include "aws_iot/client_iot.hpp"
#include "iotb/app.hpp"
#include "nlohmann/json.hpp"

using namespace std::chrono_literals;

namespace
{
/// @requirement SRS-315.7.1 Signal Handling
std::function<void(int)> shutdown_handler;
static volatile std::atomic_bool is_running = false;
void signal_handler(int signal)
{
    shutdown_handler(signal);
}
} // namespace

int main()
{
    auto aws_client = std::make_shared<aws_iot::ClientIot>();
    std::ifstream config_file("/nvidia-hpc/e2c-services/iot_gateway/main_config.json");

    iotb::App app(aws_client, nlohmann::json::parse(config_file));
    std::signal(SIGINT, signal_handler);
    std::signal(SIGTERM, signal_handler);
    std::signal(SIGHUP, signal_handler);
    shutdown_handler = [&app](int sig) {
        if (!is_running) {
            raise (sig);
        } else {
            is_running = false;
            app.stop();
        }
        signal (sig, SIG_DFL);
        raise (sig);
    };
    app.initDefaultLogger("/nvidia-hpc/e2c-services/iot_gateway/logs_aws.txt", 1'000'000, 5, 5s);
    app.init();
    is_running = true;
    app.start();
}
