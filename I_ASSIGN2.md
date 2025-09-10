# Individual Assignment 2 - Wireless Network Site Survey

In this exercise you will conduct a wireless network site survey of your living environment using free software tools available on all platforms except iOS. You will get hands-on experience with RF propagation, interference analysis, and wireless network optimization.

## Software

Install the appropriate wireless analysis tool for your platform:

* **Windows**: Download and install [Acrylic WiFi Home](https://www.acrylicwifi.com/en/wlan-software/wlan-scanner-acrylic-wifi-free/) (free version)
* **Mac**: Install [NetSpot](https://apps.apple.com/us/app/netspot-wifi-analyzer/id514951692?mt=12) from the Mac App Store.
* **Android**: Install [WiFi Analyzer](https://play.google.com/store/details?id=com.vrem.wifianalyzer) or [WiFiMan](https://play.google.com/store/apps/details?id=com.ubnt.usurvey).

For iOS users, you'll need to use your laptop - Apple's restrictions do not permit normal applications to scan Wi-Fi networks at the level of detail required for this assignment.

> [!IMPORTANT]
> If you are **unable to get any of these tools working** with the equipment available to you, please inform me as soon as possible. I am able to loan you a mobile device that you can use to complete the assignment.

## Environment Classification

**Classify your living environment without revealing personal details.**

Document the following characteristics using generic terms:

* **Type**: Apartment, Townhouse, Single-family home...
* **Construction Materials (if known)**: Primarily wood frame, brick, concrete, metal...
* **Floor Level**: Ground level, middle floors, upper floors (apartment or apartment houses only; for single-family homes use your first floor)
* **Approximate Age**: Modern (post-2010), Recent (1990-2010), Older (pre-1990)

## Part 1: Wi-Fi Network Discovery and Analysis

### Network Density Survey

From **three different locations** within your living space, conduct wireless network scans and document:

1. **Network Count by Band**:

   * Total number of visible 2.4GHz networks
   * Total number of visible 5GHz networks
   * Number of networks broadcasting on **both** bands

    > [!TIP]
    > You might see the same network listed multiple times within the same frequency. This means that network has *multiple hotspots*. You should count each listed network as one, even if they share the same name - when measuring for interference, the SSID is irrelevant - only the fact that a device is transmitting on that frequency matters.

2. **Channel Distribution Analysis**:

   * Create a table showing how many networks use each 2.4GHz channel (1-11)
   * Create a table showing 5GHz channel usage patterns
   * Identify the most **congested channels**

> [!IMPORTANT]
> If you live on campus in a dorm room, or in a shared living space with managed Internet (i.e. someone else, like a landlord, manages the Wi-Fi), you will may not be able to select a specific network. In particular, ResNet exposes potentially hundreds of access points to cover the entire living community complex.
> 
> If you are in this situation, you may do this exercise **in Carkoski Commons** using the `CSProject` network. Note that you do not need to *connect* to the `CSProject` network to scan for it and determine its transmit power.
>
> You may notice *multiple hotspots* advertising the CSProject network. IF so, you can "hone in" on one single access point by checking and matching its **MAC address** in your scans. Some scanners may allow you to filter the network list to only show a specific network.

### Signal Propagation Analysis

For your **own network only**, measure and document:

1. **Signal Strength Mapping**:

   * Measure signal strength (dBm) at 5-6 different locations throughout your space
   * Use generic location descriptions: "Kitchen Corner", "Bedroom Center", "Living Area Far End"
   * Note any dead zones or areas of poor coverage

2. **Interference Pattern Identification**:

   * Identify which neighboring networks cause the most interference with your network
   * Note any potential non-Wi-Fi interference sources within your living space (microwaves, Bluetooth devices, etc.)

## Part 2: Optimization Analysis and Recommendations

### Wi-Fi Optimization Strategy

Based on your analysis, develop recommendations for:

1. **Channel Selection**:

   * Recommend optimal channels for 2.4GHz and 5GHz
   * Justify recommendations based on congestion analysis
   * Consider both current and potential future interference

2. **Access Point Placement**:

   * Recommend optimal router/access point locations
   * Identify potential additional access point locations for better coverage if necessary
   * Consider impact of building materials on signal propagation

## Submission: Report and Supporting Data

### Report Format

Create a **2-5 page technical report** containing:

1. **Executive Summary** (1 page):

   * Key findings and recommendations
   * Summary of optimization opportunities

2. **Methodology** (2-3 pages):

   * Tools and techniques used
   * Environment classification and testing approach
   * Privacy preservation methods employed

3. **Wi-Fi Analysis Results** (4-5 pages):

   * Network density and channel analysis
   * Signal propagation findings
   * Include charts and graphs of data as appropriate (you can use Excel or any other diagramming tool of your choosing)

4. **Optimization Recommendations** (2-3 pages):

   * Specific configuration recommendations
   * Justification based on measured data

5. **Conclusions and Limitations** (1-2 pages):

   * Key learnings and insights
   * Limitations of the analysis approach
   * Real-world applicability
   * Include at least two screenshots of analysis tools (with sensitive data redacted)

## Grading

This assignment is due **September 21, 2025** at 11:59 PM.

This is an **individual** assignment. All class members must submit an original, independently created submission.

> [!WARNING]
> Remember that, as with any task involving network scanning and testing, you **must not** exceed any established access rules and restrictions.
>
> Passively scanning for Wi-Fi networks, on its own, is not "intrusion", since your device must do that all the time when connecting to Wi-Fi. However, *changing* settings on devices you don't own or control is asking for trouble.
>
> This assignment has been designed to involve only *passive* scanning of networks, to respect privacy and ethics. Your report should *not* actually be implemented unless you have full control and access to your own devices and wish to try your plan out. Note that verifying your plan's validity is *not* part of the assignment - you only need suggest a plan with reasoned arguments based on your findings from passive scanning.

### Grading Rubric

| Component | Points | Notes |
|-|-|-|
| Techincal Analysis | 40 | Point loss for:<br />- Incomplete data collection<br />- Inconsistencies or obvious inaccuracies in data<br />- Missing analysis of resuls |
| Recommendation Quality | 40 | Point loss for:<br />- Limited or no actionable recommendations<br />- Failure to identify and consider obvious factors (e.g. interference) |
| Report Quality | 20 | Point loss for:<br />- Significant grammatical or typographical errors<br />- Unprofessional tone or language<br />- Incorrect usage of technical terminology<br />- Missing content |

This assignment is worth **100 points**.

Late submissions will receive a total loss of percentage of earned points based on the syllabus's Late Work policy. **Submissions 3 days late or later will receive 0 points.** See the [syllabus](SYLLABUS.md) for details on [late work submissions](SYLLABUS.md#deadlines).

# Hints

* **dBm** is the measure of signal strength. It approaches - but never equals - `0`. Lower negative values mean weaker signals. A very strong signal - i.e. your phone directly on top of the access point - will likely be in the high -20's. Usable strengths extend down to around -75 dBm, but the usability of weaker signals varies.
* In the US, 2.4GHz Wi-Fi standards allocate **11 channels**. However, these channels **overlap** - the only "pure" channels are `1`, `6`, and `11`. Therefore, these channels are favored for 2.4GHz systems.
  * However, you might find a slight advantage to using a channel in between the main channels if you have weak signals on two of the channels. For example, if you have weak signals on both channels 1 and 6, putting your strong signal on channel 3 may be more beneficial than on either 1 or 6.
