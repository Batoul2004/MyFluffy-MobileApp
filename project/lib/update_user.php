<?php
include 'config.php';

$id = $_POST['id'];
$username = $_POST['username'];
$profile_image = $_POST['profile_image'];

$sql = "UPDATE users SET username = '$username', profile_image = '$profile_image' WHERE id = $id";

if ($conn->query($sql) === TRUE) {
    echo json_encode(["success" => "User updated successfully"]);
} else {
    echo json_encode(["error" => "Error updating user: " . $conn->error]);
}

$conn->close();
?>
