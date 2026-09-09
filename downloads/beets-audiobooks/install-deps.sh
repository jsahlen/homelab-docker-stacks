#!/bin/bash
echo "Install system packages"
apk add -U --no-cache \
	build-base \
	cmake \
	python3-dev \
	py3-pip \
	llvm20-dev \
	llvm20-static

echo "Create fake libraries needed by llvmlite"
ar rcs /usr/lib/llvm20/lib/libLLVMTestingAnnotations.a && \
	ar rcs /usr/lib/llvm20/lib/libLLVMTestingSupport.a && \
	ar rcs /usr/lib/llvm20/lib/libllvm_gtest.a && \
	ar rcs /usr/lib/llvm20/lib/libllvm_gtest_main.a

echo "Installing Python packages"
#pip install --upgrade pip
pip install --upgrade --no-cache-dir --break-system-packages pip beets-audible beets-filetote
