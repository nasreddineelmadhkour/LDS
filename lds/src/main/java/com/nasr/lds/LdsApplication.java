package com.nasr.lds;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.net.UnknownHostException;
import java.util.Enumeration;

@SpringBootApplication
public class LdsApplication {

    public static void main(String[] args) {
        SpringApplication.run(LdsApplication.class, args);

        try {
            Enumeration<NetworkInterface> interfaces = NetworkInterface.getNetworkInterfaces();
            while (interfaces.hasMoreElements()) {
                NetworkInterface networkInterface = interfaces.nextElement();

                // Check if the interface is Wi-Fi (usually named 'wlan' on Linux, 'en' on macOS)
                if (networkInterface.getName().startsWith("wlan") || networkInterface.getDisplayName().toLowerCase().contains("wi-fi")) {
                    Enumeration<InetAddress> addresses = networkInterface.getInetAddresses();
                    while (addresses.hasMoreElements()) {
                        InetAddress ip = addresses.nextElement();
                        if (!ip.isLoopbackAddress() && ip.getHostAddress().indexOf(':') == -1) { // Ignore IPv6
                            System.out.println("Wi-Fi IP address: " + ip.getHostAddress());
                        }
                    }
                }
            }
        } catch (SocketException e) {
            System.err.println("Unable to get Wi-Fi IP address: " + e.getMessage());
        }
    }

}
