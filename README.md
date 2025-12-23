# ArchiveTeam Warrior on Railway

This repository deploys a fully functional **ArchiveTeam Warrior** instance on [https://railway.app](https://railway.com?referralCode=3m2LtM) using the official pre-built Docker image.

The Warrior helps preserve websites and online content by participating in ArchiveTeam's distributed archiving projects.

## Deployment
[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/archiveteam-warrior?referralCode=3m2LtM&utm_medium=integration&utm_source=template&utm_campaign=generic)

Deploy on Railway with this [Template](https://railway.com/deploy/archiveteam-warrior?referralCode=3m2LtM&utm_medium=integration&utm_source=template&utm_campaign=generic)

## Configuration (Environment Variables)

Add these variables in the Railway dashboard (Service → Variables):

| Variable              | Description                                                                 | Example           | Required? |
|-----------------------|-----------------------------------------------------------------------------|--------------------------------|-----------|
| `DOWNLOADER`          | Your nickname/username – appears on the leaderboard for credit              | `myusername`                   | **Yes**   |
| `SELECTED_PROJECT`    | Project to work on. Use `auto` to join the most urgent/current project      | `auto`                         | No        |
| `CONCURRENT_ITEMS`    | Number of items to download simultaneously (adjust based on plan resources) | `6`       | No        |
| `SHARED_RSYNC_THREADS`| Number of rsync upload threads                                              | `20`                           | No        |
| `HTTP_USERNAME`       | Basic auth username for the web interface (optional security)               | `admin`                        | No        |
| `HTTP_PASSWORD`       | Basic auth password                                                         | `strongpassword`               | No        |

## Access

After deployment, your Warrior web interface will be available at:

`https://your-project.up.railway.app`

(Or the custom domain you set)

You’ll see the familiar Warrior UI where you can monitor progress, pause, or switch projects.

## Credits & Links

- Official Warrior Docker Image: https://github.com/ArchiveTeam/warrior-dockerfile
- ArchiveTeam: https://archiveteam.org
- Current Projects: https://tracker.archiveteam.org
