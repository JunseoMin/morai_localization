#include <ros/ros.h>
#include "sensor_msgs/Imu.h"

class ImuRepub
{
private:
    ros::NodeHandle nh_;
    ros::Subscriber imu_subs_;
    ros::Publisher imu_repub_;

public:
    ImuRepub(const ros::NodeHandle& nh) : nh_(nh)
    {
        imu_subs_ = nh_.subscribe("/imu/data", 1000, &ImuRepub::imuCB, this);
        imu_repub_ = nh_.advertise<sensor_msgs::Imu>("/imu_z_removed", 1000);
    }

    void imuCB(const sensor_msgs::Imu::ConstPtr& msg)
    {
        sensor_msgs::Imu modified_msg = *msg;
        modified_msg.linear_acceleration.z -= 9.8;
        imu_repub_.publish(modified_msg);
    }

    ~ImuRepub() {}
};

int main(int argc, char* argv[])
{
    ros::init(argc, argv, "imu_republisher");
    ros::NodeHandle nh;
    ImuRepub imuRepub(nh);
    ros::spin();
    return 0;
}
