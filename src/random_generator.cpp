#include "rclcpp/rclcpp.hpp"
#include "random_service/srv/query.hpp"
#include <random>
#include <sstream>

using std::placeholders::_1;
using std::placeholders::_2;

class RandomGeneratorNode : public rclcpp::Node
{
public:
    RandomGeneratorNode() : Node("random_generator")
    {
        service_ = this->create_service<random_service::srv::Query>(
            "query", std::bind(&RandomGeneratorNode::cb, this, _1, _2));
    }

private:
    void cb(const std::shared_ptr<random_service::srv::Query::Request> request,
            std::shared_ptr<random_service::srv::Query::Response> response)
    {
        int loop = request->num_digit + 1;

        std::vector<int> mylist(loop);
        std::random_device rd;
        std::mt19937 gen(rd());
        std::uniform_int_distribution<> dis(0, 9);

        for (int i = 1; i < loop; ++i)
        {
            mylist[i] = dis(gen);
        }

        std::stringstream ss;
        for (int h = 1; h < loop; ++h)
        {
            ss << mylist[h];
        }

        response->n_digit_number = std::stoi(ss.str());
    }

    rclcpp::Service<random_service::srv::Query>::SharedPtr service_;
};

int main(int argc, char **argv)
{
    rclcpp::init(argc, argv);
    rclcpp::spin(std::make_shared<RandomGeneratorNode>());
    rclcpp::shutdown();
    return 0;
}

